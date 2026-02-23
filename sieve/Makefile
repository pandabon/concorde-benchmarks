sieve_c_src = sieve.c 

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

sieve_bin = sieve
sieve_pin_bin = sieve-pin
sieve_gem5_bin = sieve-gem5

$(sieve_bin): $(sieve_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(sieve_c_src) $(LDFLAGS) -o $@

$(sieve_pin_bin): $(sieve_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(sieve_c_src) $(LDFLAGS) -o $@

$(sieve_gem5_bin): $(sieve_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(sieve_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(sieve_bin)
build-pin: $(sieve_pin_bin)
build-gem5: $(sieve_gem5_bin)

run: $(sieve_bin)
	./$(sieve_bin)

clean:
	rm -f $(sieve_bin) $(sieve_pin_bin) $(sieve_gem5_bin) *.o