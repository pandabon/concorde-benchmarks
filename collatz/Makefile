collatz_c_src = collatz.c 

# Path to peregrine-gem5 (override from env or command line, e.g. make PEREGRINE_GEM5=/path/to/peregrine-gem5)
PEREGRINE_GEM5 ?= /home/ubuntu/peregrine-gem5
GEM5_INCLUDE = $(PEREGRINE_GEM5)/include
GEM5_ABI ?= x86
GEM5_LIB = $(PEREGRINE_GEM5)/util/m5/build/$(GEM5_ABI)/out/libm5.a

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
GEM5_OPTS = -I$(GEM5_INCLUDE) -DGEM5
GEM5_LDFLAGS = $(GEM5_LIB)

CC ?= gcc
CFLAGS ?= -O1 -mno-sse -mno-avx -fno-tree-vectorize --static
LDFLAGS ?=

collatz_bin = collatz
collatz_pin_bin = collatz-pin
collatz_gem5_bin = collatz-gem5

$(collatz_bin): $(collatz_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(collatz_c_src) $(LDFLAGS) -o $@

$(collatz_pin_bin): $(collatz_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(collatz_c_src) $(LDFLAGS) -o $@

$(collatz_gem5_bin): $(collatz_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(collatz_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(collatz_bin)
build-pin: $(collatz_pin_bin)
build-gem5: $(collatz_gem5_bin)

run: $(collatz_bin)
	./$(collatz_bin)

clean:
	rm -f $(collatz_bin) $(collatz_pin_bin) $(collatz_gem5_bin) *.o