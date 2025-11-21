towers_c_src = towers_main.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?=

towers_bin = towers
$(towers_bin): $(towers_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(towers_c_src) $(LDFLAGS) -o $(towers_bin)

.PHONY: build run clean

build: $(towers_bin)

run: $(towers_bin)
	./$(towers_bin)

clean:
	rm -f $(towers_bin) *.o