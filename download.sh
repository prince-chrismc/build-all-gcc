#!/bin/bash

# Prerequisites:
#  - sudo apt install wget build-essential m4

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

# Function to configure and build G++
build_gcc() {
    local gcc_dir=$1
    # Check if the directory exists
    if [[ ! -d "$gcc_dir" ]]; then
        mkdir -p "$gcc_dir"
    fi
    cd "$gcc_dir"

    # Check for GMP, MPFR, MPC dependencies
    if ! pkg-config --exists gmp > /dev/null 2>&1; then
        echo "GMP not found. Downloading..."
        gmp_url="https://ftp.gnu.org/pub/gnu/gmp/gmp-6.3.0.tar.xz"
        download_file "$gmp_url"
        extract_archive "gmp-6.3.0.tar.xz"
        cd gmp-6.3.0
        ./configure && make -j $(nproc) && make install
        cd ..
    fi

    if ! pkg-config --exists mpfr > /dev/null 2>&1; then
        echo "MPFR not found. Downloading..."
        mpfr_url="https://ftp.gnu.org/pub/gnu/mpfr/mpfr-4.2.0.tar.xz"
        download_file "$mpfr_url"
        extract_archive "mpfr-4.2.0.tar.xz"
        cd mpfr-4.2.0
        ./configure && make -j $(nproc) && make install
        cd ..
    fi

    if [[ ! -f /usr/local/include/mpc.h ]]; then
        echo "MPC not found. Downloading..."
        mpc_url="https://ftp.gnu.org/pub/gnu/mpc/mpc-1.3.1.tar.gz"
        download_file "$mpc_url"
        extract_archive "mpc-1.3.1.tar.gz"
        cd mpc-1.3.1
        ./configure && make -j $(nproc) && make install
        cd ..
    fi


    ./configure --enable-languages=c,c++ --disable-multilib --disable-bootstrap
    make -j $(nproc)
    make -j $(nproc)
    make install
}

if ! which g++-13 > /dev/null 2>&1; then
    # Download the latest G++ source code
    gcc13_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    download_file "$gcc13_url"

    # Extract the downloaded archive
    extract_archive "gcc-13.2.0.tar.xz"

    # Build G++ with the desired options
    build_gcc "gcc-13.2.0"
fi

# if ! which g++-12 > /dev/null 2>&1; then
#     # Download GCC 12.4 source code
#     gcc12_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-12.4.0/gcc-12.4.0.tar.xz"
#     download_file "$gcc12_url"

#     # Extract the downloaded archive
#     extract_archive "gcc-12.4.0.tar.xz"

#     # Build G++ with the desired options
#     build_gcc "gcc-12.4.0"
# fi

if ! which g++-11 > /dev/null 2>&1; then
    # Download GCC 12.4 source code
    gcc11_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-11.5.0/gcc-11.5.0.tar.xz"
    download_file "$gcc11_url"

    # Extract the downloaded archive
    extract_archive "gcc-11.5.0.tar.xz"

    # Build G++ with the desired options
    build_gcc "gcc-11.5.0"
fi

if ! which g++-10 > /dev/null 2>&1; then
    # Download GCC 12.4 source code
    gcc10_url="https://ftp.gnu.org/pub/gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.xz"
    download_file "$gcc10_url"

    # Extract the downloaded archive
    extract_archive "gcc-10.5.0.tar.xz"

    # Build G++ with the desired options
    build_gcc "gcc-10.5.0"
fi
