#!/bin/sh

depmod -b /var

modprobe -d /var hellomod
