linpack_c_src = linpack.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?=

linpack_bin = linpack
$(linpack_bin): $(linpack_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(linpack_c_src) $(LDFLAGS) -o $(linpack_bin)

.PHONY: build run clean

build: $(linpack_bin)

run: $(linpack_bin)
	./$(linpack_bin)

clean:
	rm -f $(linpack_bin) *.o