sparse_c_src = sparse.c 

# Path to peregrine-gem5 (override from env or command line, e.g. make PEREGRINE_GEM5=/path/to/peregrine-gem5)
PEREGRINE_GEM5 ?= /home/ubuntu/peregrine-gem5
GEM5_INCLUDE = $(PEREGRINE_GEM5)/include
GEM5_ABI ?= x86
GEM5_LIB = $(PEREGRINE_GEM5)/util/m5/build/$(GEM5_ABI)/out/libm5.a

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
GEM5_OPTS = -I$(GEM5_INCLUDE) -DGEM5
GEM5_LDFLAGS = $(GEM5_LIB)

CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?=

sparse_bin = sparse
sparse_pin_bin = sparse-pin
sparse_gem5_bin = sparse-gem5

$(sparse_bin): $(sparse_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(sparse_c_src) $(LDFLAGS) -o $@

$(sparse_pin_bin): $(sparse_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(sparse_c_src) $(LDFLAGS) -o $@

$(sparse_gem5_bin): $(sparse_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(sparse_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(sparse_bin)
build-pin: $(sparse_pin_bin)
build-gem5: $(sparse_gem5_bin)

run: $(sparse_bin)
	./$(sparse_bin)

clean:
	rm -f $(sparse_bin) $(sparse_pin_bin) $(sparse_gem5_bin) *.o