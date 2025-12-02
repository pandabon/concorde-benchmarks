sparse_c_src = sparse.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?=

sparse_bin = sparse
$(sparse_bin): $(sparse_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(sparse_c_src) $(LDFLAGS) -o $(sparse_bin)

.PHONY: build run clean

build: $(sparse_bin)

run: $(sparse_bin)
	./$(sparse_bin)

clean:
	rm -f $(sparse_bin) *.o