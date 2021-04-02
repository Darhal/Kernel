PREFIX=$(HOME)/opt/cross/bin/
COMPILER64=$(PREFIX)aarch64-elf
KERNEL_NAME=kernel8
CC_FLAGS=-O2 -Wall -Wextra -Wno-unused-parameter


SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
CFLAGS = -Wall -Wextra -Wno-unused-parameter -O2 -ffreestanding -nostdinc -nostdlib

all: clean $(KERNEL_NAME).img

boot.o: boot.S
	$(COMPILER64)-gcc $(CFLAGS) -c boot.S -o boot.o

%.o: %.c
	$(COMPILER64)-gcc $(CFLAGS) -c $< -o $@

$(KERNEL_NAME).img: boot.o $(OBJS)
	$(COMPILER64)-ld -nostdlib boot.o $(OBJS) -T linker.ld -o $(KERNEL_NAME).elf
	$(COMPILER64)-objcopy -O binary $(KERNEL_NAME).elf $(KERNEL_NAME).img

clean:
	rm $(KERNEL_NAME).elf *.o

run:
	qemu-system-aarch64 -M raspi3 -kernel $(KERNEL_NAME).img -serial null -serial stdio