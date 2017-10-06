A kernel module distributed as a system container

```
## The Docker container is built by the Makefile
# make

## Pull the just built container into the ostree storage
# atomic pull --storage ostree docker:hellomod:latest

# atomic install --system --system-package=no hellomod

## Helper script
# /usr/local/sbin/install_hellomod.sh

# dmesg -c
[182574.018588] Hello Atomic!

## Another helper script
# /usr/local/sbin/uninstall_hellomod.sh

# dmesg -c
[182579.626505] Good bye Atomic.

```
