linpack_c_src = linpack.c 

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

linpack_bin = linpack
linpack_pin_bin = linpack-pin
linpack_gem5_bin = linpack-gem5

$(linpack_bin): $(linpack_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(linpack_c_src) $(LDFLAGS) -o $@

$(linpack_pin_bin): $(linpack_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(linpack_c_src) $(LDFLAGS) -o $@

$(linpack_gem5_bin): $(linpack_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(linpack_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(linpack_bin)
build-pin: $(linpack_pin_bin)
build-gem5: $(linpack_gem5_bin)

run: $(linpack_bin)
	./$(linpack_bin)

clean:
	rm -f $(linpack_bin) $(linpack_pin_bin) $(linpack_gem5_bin) *.o