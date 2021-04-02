PREFIX=$(HOME)/opt/cross/bin/
TARGET=arm-none-eabi
COMPILER=$(PREFIX)$(TARGET)
KERNEL_NAME=kernel
CC_FLAGS=-O2 -Wall -Wextra -Wno-unused-parameter

kernel.bin:
	$(COMPILER)-gcc -mcpu=cortex-a7 -fpic -ffreestanding -c boot.S -o boot.o
	$(COMPILER)-gcc -fpic -ffreestanding -std=gnu99 -c kernel.c -o kernel.o $(CC_FLAGS)
	$(COMPILER)-gcc -T linker.ld -o $(KERNEL_NAME).elf -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

run: kernel.bin
	qemu-system-arm -m 256 -M raspi2 -serial stdio -kernel $(KERNEL_NAME).elf

clean:
	rm boot.o kernel.o $(KERNEL_NAME).elf
