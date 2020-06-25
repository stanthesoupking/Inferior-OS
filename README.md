# Inferior OS
Messing around with ARM assembly on a Raspberry Pi.

Note: only Raspberry Pi models 1B and Zero are supported currently.

## Building
In order to compile you'll either need access to an ARM system or a [cross-assemler](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

To compile, run the following from the project's root directory.
```
./make.sh
```

## Installation
To install, copy `kernel.img` onto the `boot` partition of a SD card that already has an OS installed (such as Raspbian for example). This will overwrite the existing kernel on the SD card so you may wish to back up the original kernel.