TARGET   = sample
SRC      = main.c  
OBJS     = main.o 

LIBS = -lc


PREFIX  = armv6-freebsd
CC      = clang -v
#LD	= $PREFIX-ld -v
CFLAGS  = -march=armv7-a -mfloat-abi=hard -ccc-host-triple arm-elf -integrated-as --sysroot /usr/armv6-freebsd -static
ASFLAGS = $(CFLAGS)

all: $(TARGET).elf

$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $(SRC) $(LIBS) -o $@
	$(PREFIX)-strip $@

clean:
	@rm -rf $(TARGET).elf $(OBJS) 


