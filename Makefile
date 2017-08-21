SRCS = \
	win32-spawner-ex.c

OBJS = $(subst .c,.o,$(SRCS))

CFLAGS = -Ic:/msys64/mingw64/include/lua5.1 -Wall
LIBS = -llua5.1
TARGET = spawner-ex
ifeq ($(OS),Windows_NT)
TARGET := $(TARGET).dll
else
TARGET := $(TARGET).so
endif

.SUFFIXES: .c .o

all : $(TARGET)

$(TARGET) : $(OBJS)
	gcc -shared -o $@ $(OBJS) $(LIBS)

.c.o :
	gcc -c $(CFLAGS) -I. $< -o $@

clean :
	rm -f *.o $(TARGET)
