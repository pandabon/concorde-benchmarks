towers_c_src = towers_main.c 

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

# build: plain host binary; build-pin: towers-pin; build-gem5: towers-gem5
towers_bin = towers
towers_pin_bin = towers-pin
towers_gem5_bin = towers-gem5

$(towers_bin): $(towers_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(towers_c_src) $(LDFLAGS) -o $@

$(towers_pin_bin): $(towers_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(towers_c_src) $(LDFLAGS) -o $@

$(towers_gem5_bin): $(towers_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(towers_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(towers_bin)
build-pin: $(towers_pin_bin)
build-gem5: $(towers_gem5_bin)

run: $(towers_bin)
	./$(towers_bin)

clean:
	rm -f $(towers_bin) $(towers_pin_bin) $(towers_gem5_bin) *.o