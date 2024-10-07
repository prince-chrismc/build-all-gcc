#!/bin/bash

# Prerequisites:
#  - sudo apt install wget build-essential m4 pkg-config

# Function to download a file from a URL
download_file() {
    local url=$1
    local filename=$(basename "$url")
    wget -c "$url" -O "$filename"
}

# Function to extract a tar archive
extract_archive() {
    local archive=$1
    if [[ "$archive" =~ \.gz$ ]]; then
        tar -xzf "$archive"
    elif [[ "$archive" =~ \.xz$ ]]; then
        tar -xJf "$archive"
    else
        echo "Unsupported archive format: $archive"
        exit 1
    fi
}

function check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

# Function to configure and build G++
build_gcc() {
    local gcc_dir=$1
    # Check if the directory exists
    if [[ ! -d "$gcc_dir" ]]; then
        mkdir -p "$gcc_dir"
    fi

    # Check for GMP, MPFR, MPC dependencies
    if ! pkg-config --exists gmp > /dev/null 2>&1; then
        echo "GMP not found. Downloading..."
        gmp_url="https://ftp.gnu.org/pub/gnu/gmp/gmp-6.3.0.tar.xz"
        download_file "$gmp_url"
        extract_archive "gmp-6.3.0.tar.xz"
        cd gmp-6.3.0
        ./configure && make -j $(nproc) && check_root make install
        cd ..
    fi

    if ! pkg-config --exists mpfr > /dev/null 2>&1; then
        echo "MPFR not found. Downloading..."
        mpfr_url="https://ftp.gnu.org/pub/gnu/mpfr/mpfr-4.2.0.tar.xz"
        download_file "$mpfr_url"
        extract_archive "mpfr-4.2.0.tar.xz"
        cd mpfr-4.2.0
        ./configure && make -j $(nproc) && check_root make install
        cd ..
    fi

    if [[ ! -f /usr/local/include/mpc.h && ! -f /usr/local/lib/libmpc.so ]]; then
        echo "MPC not found. Downloading..."
        mpc_url="https://ftp.gnu.org/pub/gnu/mpc/mpc-1.3.1.tar.gz"
        download_file "$mpc_url"
        extract_archive "mpc-1.3.1.tar.gz"
        cd mpc-1.3.1
        ./configure && make -j $(nproc) && check_root make install
        cd ..
    fi

    local gcc_version=$(gcc --version | head -n 1 | awk '{print $3}')
    local ubuntu_version=$(lsb_release -rs)
    mkdir -p build/$gcc_dir
    cd build/$gcc_dir
    ../../$gcc_dir/configure --with-pkgversion="GCC $gcc_version on Ubuntu $ubuntu_version" \
        --prefix=/usr/local/$gcc_dir --enable-languages=c,c++ \
        --disable-gcov --disable-multilib --disable-bootstrap
    make -j $(nproc)
    make -j $(nproc)
    check_root make install

    cd ../..
}

# Function to install GCC
install_gcc() {
    local gcc_version=$1
    local major_version=${gcc_version%%.*}

    echo "Building g++-$major_version ($gcc_version)..."

    # Check if GCC version exists
    if ! which g++-$major_version > /dev/null 2>&1; then
        local gcc_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-$gcc_version/gcc-$gcc_version.tar.xz"

        # Download, extract, and build GCC
        download_file "$gcc_url"
        extract_archive "gcc-$gcc_version.tar.xz"
        build_gcc "gcc-$gcc_version"

        # Create symbolic link (requires root)
        check_root ln -s "/usr/local/gcc-$gcc_version/bin/g++" "/usr/local/bin/g++-$major_version"
    fi
}

install_gcc_old() {
    local gcc_version=$1
    local major_version=${gcc_version%%.*}
    local minor_patch_version=${gcc_version#*.}
    local minor_version=${minor_patch_version%%.*}
    echo "Building g++-$major_version.$minor_version ($gcc_version)..."

    # Check if GCC version exists
    if ! which g++-$major_version.$minor_version > /dev/null 2>&1; then
        local gcc_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-$gcc_version/gcc-$gcc_version.tar.gz"

        # Download, extract, and build GCC
        download_file "$gcc_url"
        extract_archive "gcc-$gcc_version.tar.gz"

        # Make sure to apply any patches we might have
        cd "gcc-$gcc_version"
        for patch in ../patches/gcc-$gcc_version/*; do
            patch -p1 --verbose -i "$patch"
        done
        cd ..
        
        build_gcc "gcc-$gcc_version"

        # Create symbolic link (requires root)
        check_root ln -s "/usr/local/gcc-$gcc_version/bin/g++" "/usr/local/bin/g++-$major_version.$minor_version"
    fi
}

install_gcc "14.2.0"
install_gcc "13.3.0"
install_gcc "12.4.0"
install_gcc "11.5.0"
install_gcc "10.5.0"
install_gcc "9.5.0"
install_gcc "8.5.0"
install_gcc "7.5.0"
install_gcc "6.5.0"
install_gcc "5.5.0"

install_gcc_old "4.8.5"
# install_gcc_old "4.3.6"
# CC=/usr/local/gcc-4.8.5/bin/gcc CXX=/usr/local/gcc-4.8.5/bin/g++ install_gcc_old "3.4.6"
