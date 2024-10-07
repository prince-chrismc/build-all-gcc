#  Building All Version of GCC

```sh
g++ main.cpp -o hello_world
```

## 18.04.6 LTS (Bionic Beaver) 

```sh
$ g++ --version
g++ (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
```

### G++ 3

Does Not Build!

```
In file included from /usr/include/fcntl.h:290:0,
                 from ../../../gcc-3.4.6/gcc/system.h:214,
                 from ../../../gcc-3.4.6/gcc/collect2.c:30:
In function ‘open’,
    inlined from ‘collect_execute’ at ../../../gcc-3.4.6/gcc/collect2.c:1537:20:
/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:4: error: call to ‘__open_missing_mode’ declared with attribute error: open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
    __open_missing_mode ();
    ^~~~~~~~~~~~~~~~~~~~~~
Makefile:1388: recipe for target 'collect2.o' failed
```

### G++ 4

Does not build!

```
In file included from ../../../../gcc-4.8.5/libgcc/unwind-dw2.c:405:0:
./md-unwind-support.h: In function ‘x86_64_fallback_frame_state’:
./md-unwind-support.h:65:47: error: dereferencing pointer to incomplete type
       sc = (struct sigcontext *) (void *) &uc_->uc_mcontext;
                                               ^
../../../../gcc-4.8.5/libgcc/shared-object.mk:14: recipe for target 'unwind-dw2.o' failed
```

Fixed in: <https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=16b277761b432510ad6dcf72d877ae72b5f0a4b7>

```
In file included from ../../../gcc-4.8.5/gcc/cp/except.c:1008:0:
cfns.gperf: In function ‘const char* libc_name_p(const char*, unsigned int)’:
cfns.gperf:101:1: error: ‘const char* libc_name_p(const char*, unsigned int)’ redeclared inline with ‘gnu_inline’ attribute
cfns.gperf:26:14: note: ‘const char* libc_name_p(const char*, unsigned int)’ previously declared here
```

Fixed in <https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=4c212bc2507fc8ab8caba7c5afc1257707572c45>

```
.libs/tsan_platform_linux.o ../../../../../gcc-4.8.5/libsanitizer/tsan/tsan_platform_linux.cc: In function ‘int __tsan::ExtractResolvFDs(void*, int*, int)’: ../../../../../gcc-4.8.5/libsanitizer/tsan/tsan_platform_linux.cc:295:16: error: ‘statp’ was not declared in this scope __res_state *statp = (__res_state*)state;
```

Fixed in <https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=dc517c7308573905a2ecac4c942a2cdc322a4003>

### G++ 5

g++-5 (Ubuntu 5.5.0-12ubuntu1) 5.5.0 20171010

GNU readelf (GNU Binutils for Ubuntu) 2.30

```sh
$ readelf -V hello_world

Version symbols section '.gnu.version' contains 14 entries:
 Addr: 0000000000000588  Offset: 0x000588  Link: 5 (.dynsym)
  000:   0 (*local*)       2 (GLIBC_2.2.5)   3 (GLIBCXX_3.4)   2 (GLIBC_2.2.5)
  004:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   0 (*local*)       3 (GLIBCXX_3.4)
  008:   0 (*local*)       2 (GLIBC_2.2.5)   0 (*local*)       0 (*local*)
  00c:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)

Version needs section '.gnu.version_r' contains 2 entries:
 Addr: 0x00000000000005a8  Offset: 0x0005a8  Link: 6 (.dynstr)
  000000: Version: 1  File: libstdc++.so.6  Cnt: 1
  0x0010:   Name: GLIBCXX_3.4  Flags: none  Version: 3
  0x0020: Version: 1  File: libc.so.6  Cnt: 1
  0x0030:   Name: GLIBC_2.2.5  Flags: none  Version: 2
```

### G++ 6

g++-6 (Ubuntu 6.5.0-2ubuntu1~18.04) 6.5.0 20181026

```sh
$ readelf -V hello_world

Version symbols section '.gnu.version' contains 14 entries:
 Addr: 0000000000000588  Offset: 0x000588  Link: 5 (.dynsym)
  000:   0 (*local*)       2 (GLIBC_2.2.5)   3 (GLIBCXX_3.4)   2 (GLIBC_2.2.5)
  004:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   0 (*local*)       3 (GLIBCXX_3.4)
  008:   0 (*local*)       2 (GLIBC_2.2.5)   0 (*local*)       0 (*local*)
  00c:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)

Version needs section '.gnu.version_r' contains 2 entries:
 Addr: 0x00000000000005a8  Offset: 0x0005a8  Link: 6 (.dynstr)
  000000: Version: 1  File: libstdc++.so.6  Cnt: 1
  0x0010:   Name: GLIBCXX_3.4  Flags: none  Version: 3
  0x0020: Version: 1  File: libc.so.6  Cnt: 1
  0x0030:   Name: GLIBC_2.2.5  Flags: none  Version: 2
```

## G++7

g++-7 (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0

```sh
$ readelf -V hello_world

Version symbols section '.gnu.version' contains 13 entries:
 Addr: 000000000000055c  Offset: 0x00055c  Link: 5 (.dynsym)
  000:   0 (*local*)       2 (GLIBC_2.2.5)   3 (GLIBCXX_3.4)   2 (GLIBC_2.2.5)
  004:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   0 (*local*)
  008:   2 (GLIBC_2.2.5)   0 (*local*)       0 (*local*)       3 (GLIBCXX_3.4)
  00c:   3 (GLIBCXX_3.4)

Version needs section '.gnu.version_r' contains 2 entries:
 Addr: 0x0000000000000578  Offset: 0x000578  Link: 6 (.dynstr)
  000000: Version: 1  File: libstdc++.so.6  Cnt: 1
  0x0010:   Name: GLIBCXX_3.4  Flags: none  Version: 3
  0x0020: Version: 1  File: libc.so.6  Cnt: 1
  0x0030:   Name: GLIBC_2.2.5  Flags: none  Version: 2
```

### G++8

g++-8 (Ubuntu 8.4.0-1ubuntu1~18.04) 8.4.0

```sh
$ readelf -V hello_world

Version symbols section '.gnu.version' contains 13 entries:
 Addr: 000000000000055c  Offset: 0x00055c  Link: 5 (.dynsym)
  000:   0 (*local*)       2 (GLIBC_2.2.5)   3 (GLIBCXX_3.4)   2 (GLIBC_2.2.5)
  004:   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   3 (GLIBCXX_3.4)   0 (*local*)
  008:   2 (GLIBC_2.2.5)   0 (*local*)       0 (*local*)       3 (GLIBCXX_3.4)
  00c:   3 (GLIBCXX_3.4)

Version needs section '.gnu.version_r' contains 2 entries:
 Addr: 0x0000000000000578  Offset: 0x000578  Link: 6 (.dynstr)
  000000: Version: 1  File: libstdc++.so.6  Cnt: 1
  0x0010:   Name: GLIBCXX_3.4  Flags: none  Version: 3
  0x0020: Version: 1  File: libc.so.6  Cnt: 1
  0x0030:   Name: GLIBC_2.2.5  Flags: none  Version: 2
```

## Docker

### G++13

```
Version symbols section '.gnu.version' contains 14 entries:
 Addr: 0x000000000000056a  Offset: 0x0000056a  Link: 5 (.dynsym)
  000:   0 (*local*)       0 (*local*)       0 (*local*)       2 (GLIBCXX_3.4)
  004:   3 (GLIBC_2.17)    4 (GLIBC_2.34)    2 (GLIBCXX_3.4)   2 (GLIBCXX_3.4)
  008:   2 (GLIBCXX_3.4)   5 (GLIBCXX_3.4.32)    3 (GLIBC_2.17)    1 (*global*)   
  00c:   1 (*global*)      1 (*global*)   
```

```
Version needs section '.gnu.version_r' contains 2 entries:
 Addr: 0x0000000000000588  Offset: 0x00000588  Link: 6 (.dynstr)
  000000: Version: 1  File: libc.so.6  Cnt: 2
  0x0010:   Name: GLIBC_2.34  Flags: none  Version: 4
  0x0020:   Name: GLIBC_2.17  Flags: none  Version: 3
  0x0030: Version: 1  File: libstdc++.so.6  Cnt: 2
  0x0040:   Name: GLIBCXX_3.4.32  Flags: none  Version: 5
  0x0050:   Name: GLIBCXX_3.4  Flags: none  Version: 2
```
