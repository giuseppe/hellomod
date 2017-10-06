#!/bin/sh

/usr/sbin/depmod -b /var

modprobe -d /var hellomod
