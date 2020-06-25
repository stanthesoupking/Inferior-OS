#!/bin/sh

# Clean
./clean.sh

BUILD="build"
INCLUDE="include"
SOURCE="src"

mkdir $BUILD

# Create objects
for file in $SOURCE/*.s; do
    name=${file##*/}
    base=${name%.s}
    arm-none-eabi-as -o $BUILD/$base.o $SOURCE/$name
done

for file in $SOURCE/*.c; do
    name=${file##*/}
    base=${name%.c}
    arm-none-eabi-gcc -I $INCLUDE $SOURCE/$name -c -o $BUILD/$base.o 
done


# Link
arm-none-eabi-ld build/*.o -T kernel.ld -o build/output.elf

# Make image
arm-none-eabi-objcopy build/output.elf -O binary kernel.img