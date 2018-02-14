#!/bin/bash

qemu-system-arm -M versatilepb -kernel images/zImage -append "console=ttyAMA0,115200" -nographic
