whetstone_c_src = whetstone.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?= -lm

whetstone_bin = whetstone
$(whetstone_bin): $(whetstone_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(whetstone_c_src) $(LDFLAGS) -o $(whetstone_bin)

.PHONY: build run clean

build: $(whetstone_bin)

run: $(whetstone_bin)
	./$(whetstone_bin)

clean:
	rm -f $(whetstone_bin) *.o