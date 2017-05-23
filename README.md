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
 3) Install gmake port

```
eapjutsu# cd /usr/ports/devel/gmake
eapjutsu# make install
eapjutsu# exit
```
 3) Download repository
 
 4) Copy local sources to our working directory
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

5) Compile cross toolchain for armv6 target
$ sudo make XDEV=arm XDEV_ARCH=armv6 xdev
$ cd /usr/bin
$ sudo cp ld ld.orig
$ sudo rm ld 
$ sudo ln -s armv6-freebsd-ld ld
