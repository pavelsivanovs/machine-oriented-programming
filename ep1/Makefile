TARGET := ep1
OBJ := $(TARGET)_main.o $(TARGET).o

ASFLAGS = -mcpu=xscale -alh=$*.lis -L
CFLAGS = -O0 -Wall
LDFLAGS = -g

CC := arm-linux-gnueabi-gcc
AS := arm-linux-gnueabi-as

.PHONY: all clean distclean

all: 	$(TARGET)

clean:
	$(RM) $(TARGET) *.o

allhfiles := $(wildcard *.h)

$(TARGET): 	$(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

%.o:	%.s
	$(AS) -g $(ASFLAGS) -o $@ $<

%.o:	%.c $(allhfiles)
	$(CC) -g $(CFLAGS) -o $@ -c $<

%.s:	%.c $(allhfiles)
	$(CC) $(CFLAGS) -fomit-frame-pointer -o $@ -S $<
