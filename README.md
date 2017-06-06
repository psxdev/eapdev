# eapdev
Experimental toolchain freebsd 9 for arm cortex-a8

Brief History
===================
PlayStation 4 is based on Freebsd 9, source reference is from September 10, 2011 named release 900044.

Main processor is AMD based but there is an infamous chip from Marvell that also use Freebsd but based on ARM

Some people have been working in arm-eabi branch in freebsd since a few years ago, adding a armv6 target with support for some arm boards but the main work is in freebsd 10.x so i have been backporting some of their patches to freebsd 9.

What does this do?
===================
This is a experimental patch to let compile arm contex-a8 eabi V code in freebsd 9 for educational purposes only

What do i need?
===================
A virtual machine with Freebsd 9.0 Release installed from:
http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/old-releases/amd64/ISO-IMAGES/9.0/FreeBSD-9.0-RELEASE-amd64-dvd1.iso

 1) Install it with virtualbox
 
 You must choose install src, you will need it to patch after install. Create a non root user and add to wheel group
 
 2) Login with your created non root user 
 
 3) Install sudo port

``` 
$ su -
eapjutsu# cd /usr/ports/security/sudo
eapjutsu# make install
``` 

uncomment group wheel to let use sudo to our user
```
eapjutsu# vi /usr/local/etc/sudoers
```
 4) Install gmake port

```
eapjutsu# cd /usr/ports/devel/gmake
eapjutsu# make install
eapjutsu# exit
```

 5) Download repository
 
 6) Copy local sources to our working directory
``` 
$ cd
$ mkdir work
$ 
$ cd /usr
$ tar cvf /home/bigboss/work/src.tar ./src
$ cd
$ cd work
$ tar xf src.tar
$ cd src
$ patch -p1 < ../eapjutsu_patch.txt
```
7) Compile cross toolchain for armv6 target
```
$ sudo make XDEV=arm XDEV_ARCH=armv6 xdev
```
8) Native clang is invoking /usr/bin/ld change to use our generated ld
```
$ cd /usr/bin
$ sudo cp ld ld.orig
$ sudo rm ld 
$ sudo ln -s armv6-freebsd-ld ld
```
9) Use Makefile included with your main.c
```
$ make
clang -v -march=armv7-a -mfloat-abi=hard -ccc-host-triple arm-elf -integrated-as --sysroot /usr/armv6-freebsd -static -c main.c
FreeBSD clang version 3.0 (branches/release_30 142614) 20111021
Target: arm-elf-
Thread model: posix
 "/usr/bin/clang" -cc1 -triple armv7-elf- -emit-obj -mrelax-all -disable-free -main-file-name main.c -static-define -mrelocation-model static -mdisable-fp-elim -mconstructor-aliases -target-abi apcs-gnu -target-cpu cortex-a8 -mfloat-abi hard -momit-leaf-frame-pointer -v -coverage-file main.o -resource-dir /usr/bin/../lib/clang/3.0 -isysroot /usr/armv6-freebsd -fmodule-cache-path /var/tmp/clang-module-cache -ferror-limit 19 -fmessage-length 80 -fno-signed-char -fgnu-runtime -fobjc-runtime-has-arc -fobjc-runtime-has-weak -fobjc-fragile-abi -fdiagnostics-show-option -fcolor-diagnostics -o main.o -x c main.c
clang -cc1 version 3.0 based upon llvm 3.0 hosted on x86_64-unknown-freebsd9.0
ignoring nonexistent directory "/usr/armv6-freebsd/usr/local/include"
ignoring nonexistent directory "/usr/bin/../lib/clang/3.0/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/armv6-freebsd/usr/include
End of search list.
clang -v -march=armv7-a -mfloat-abi=hard -ccc-host-triple arm-elf -integrated-as --sysroot /usr/armv6-freebsd -static main.c -lc -o sample.elf
FreeBSD clang version 3.0 (branches/release_30 142614) 20111021
Target: arm-elf-
Thread model: posix
 "/usr/bin/clang" -cc1 -triple armv7-elf- -emit-obj -mrelax-all -disable-free -main-file-name main.c -static-define -mrelocation-model static -mdisable-fp-elim -mconstructor-aliases -target-abi apcs-gnu -target-cpu cortex-a8 -mfloat-abi hard -momit-leaf-frame-pointer -v -resource-dir /usr/bin/../lib/clang/3.0 -isysroot /usr/armv6-freebsd -fmodule-cache-path /var/tmp/clang-module-cache -ferror-limit 19 -fmessage-length 80 -fno-signed-char -fgnu-runtime -fobjc-runtime-has-arc -fobjc-runtime-has-weak -fobjc-fragile-abi -fdiagnostics-show-option -fcolor-diagnostics -o /tmp/main-9GeDkO.o -x c main.c
clang -cc1 version 3.0 based upon llvm 3.0 hosted on x86_64-unknown-freebsd9.0
ignoring nonexistent directory "/usr/armv6-freebsd/usr/local/include"
ignoring nonexistent directory "/usr/bin/../lib/clang/3.0/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/armv6-freebsd/usr/include
End of search list.
 "/usr/bin/gcc" -v -march=armv7-a -mfloat-abi=hard --sysroot=/usr/armv6-freebsd -static -o sample.elf /tmp/main-9GeDkO.o -lc
Using built-in specs.
Target: amd64-undermydesk-freebsd
Configured with: FreeBSD/amd64 system compiler
Thread model: posix
gcc version 4.2.1 20070831 patched [FreeBSD]
 /usr/bin/ld --sysroot=/usr/armv6-freebsd -V -Bstatic -o sample.elf /usr/armv6-freebsd/usr/lib/crt1.o /usr/armv6-freebsd/usr/lib/crti.o /usr/armv6-freebsd/usr/lib/crtbeginT.o -L/usr/armv6-freebsd/usr/lib -L/usr/armv6-freebsd/usr/lib /tmp/main-9GeDkO.o -lc -lgcc -lgcc_eh -lc -lgcc -lgcc_eh /usr/armv6-freebsd/usr/lib/crtend.o /usr/armv6-freebsd/usr/lib/crtn.o
GNU ld 2.17.50 [FreeBSD] 2007-07-03
  Supported emulations:
   armelf_fbsd
armv6-freebsd-strip sample.elf
```
10) Checks
```
$ readelf -h sample.elf 
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           ARM
  Version:                           0x1
  Entry point address:               0x8100
  Start of program headers:          52 (bytes into file)
  Start of section headers:          119964 (bytes into file)
  Flags:                             0x5000202, has entry point, Version5 EABI, <unknown>
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         3
  Size of section headers:           40 (bytes)
  Number of section headers:         15
  Section header string table index: 14
$ readelf -A sample.elf 
Attribute Section: aeabi
File Attributes
  Tag_CPU_name: "CORTEX-A8"
  Tag_CPU_arch: v7
  Tag_CPU_arch_profile: Application
  Tag_ARM_ISA_use: Yes
  Tag_THUMB_ISA_use: Thumb-2
  Tag_VFP_arch: VFPv3
  Tag_NEON_arch: NEONv1
  Tag_ABI_FP_denormal: Needed
  Tag_ABI_FP_exceptions: Needed
  Tag_ABI_FP_number_model: IEEE 754
  Tag_ABI_align8_needed: Yes
  Tag_ABI_align8_preserved: Yes, except leaf SP
```


