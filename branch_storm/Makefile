branch_storm_c_src = branch_storm.c 

# Path to peregrine-gem5 (override from env or command line, e.g. make PEREGRINE_GEM5=/path/to/peregrine-gem5)
PEREGRINE_GEM5 ?= /home/ubuntu/peregrine-gem5
GEM5_INCLUDE = $(PEREGRINE_GEM5)/include
GEM5_ABI ?= x86
GEM5_LIB = $(PEREGRINE_GEM5)/util/m5/build/$(GEM5_ABI)/out/libm5.a

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
GEM5_OPTS = -I$(GEM5_INCLUDE) -DGEM5
GEM5_LDFLAGS = $(GEM5_LIB)

CC ?= gcc
CFLAGS ?= -O1
LDFLAGS ?=

branch_storm_bin = branch_storm
branch_storm_pin_bin = branch_storm-pin
branch_storm_gem5_bin = branch_storm-gem5

$(branch_storm_bin): $(branch_storm_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(branch_storm_c_src) $(LDFLAGS) -o $@

$(branch_storm_pin_bin): $(branch_storm_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) -DPIN $(branch_storm_c_src) $(LDFLAGS) -o $@

$(branch_storm_gem5_bin): $(branch_storm_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(GEM5_OPTS) $(branch_storm_c_src) $(LDFLAGS) $(GEM5_LDFLAGS) -o $@

.PHONY: build build-pin build-gem5 run clean

build: $(branch_storm_bin)
build-pin: $(branch_storm_pin_bin)
build-gem5: $(branch_storm_gem5_bin)

run: $(branch_storm_bin)
	./$(branch_storm_bin)

clean:
	rm -f $(branch_storm_bin) $(branch_storm_pin_bin) $(branch_storm_gem5_bin) *.o