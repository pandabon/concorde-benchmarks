whetstone_c_src = whetstone.c 

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
LDFLAGS ?= -lm

whetstone_bin = whetstone
whetstone_pin_bin = whetstone-pin
whetstone_gem5_bin = whetstone-gem5

$(whetstone_bin): $(whetstone_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(whetstone_c_src) $(LDFLAGS) -o $@

$(whetstone_pin_bin): $(whetstone_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(whetstone_c_src) $(LDFLAGS) -o $@

$(whetstone_gem5_bin): $(whetstone_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(whetstone_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(whetstone_bin)
build-pin: $(whetstone_pin_bin)
build-gem5: $(whetstone_gem5_bin)

run: $(whetstone_bin)
	./$(whetstone_bin)

clean:
	rm -f $(whetstone_bin) $(whetstone_pin_bin) $(whetstone_gem5_bin) *.o