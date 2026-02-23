# Path to peregrine-gem5 (override from env or command line, e.g. make PEREGRINE_GEM5=/path/to/peregrine-gem5)
PEREGRINE_GEM5 ?= /home/ubuntu/peregrine-gem5
GEM5_INCLUDE = $(PEREGRINE_GEM5)/include
GEM5_ABI ?= x86
GEM5_LIB = $(PEREGRINE_GEM5)/util/m5/build/$(GEM5_ABI)/out/libm5.a
GEM5_OPTS = -I$(GEM5_INCLUDE) -DGEM5
GEM5_LDFLAGS = $(GEM5_LIB)

DHRY-CFLAGS := -O3 -Wno-implicit -save-temps
DHRY-CFLAGS += -DNOENUM -DTIMES -DHZ=100
DHRY-CFLAGS += -fno-builtin-printf -fno-common -falign-functions=4

SRC = dhry_1.c dhry_2.c
HDR = dhry.h

CC ?= gcc
CFLAGS ?= -O3
LDFLAGS ?=

# build: plain host binary; build-pin: dhrystone-pin; build-gem5: dhrystone-gem5
dhrystone_bin = dhrystone
dhrystone_pin_bin = dhrystone-pin
dhrystone_gem5_bin = dhrystone-gem5

.PHONY: build build-pin build-gem5 run clean

$(dhrystone_bin): $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(DHRY-CFLAGS) $(XCFLAGS) $(SRC) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

$(dhrystone_pin_bin): $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(DHRY-CFLAGS) -DPIN $(XCFLAGS) $(SRC) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

$(dhrystone_gem5_bin): $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(DHRY-CFLAGS) $(GEM5_OPTS) $(XCFLAGS) $(SRC) $(LDFLAGS) $(GEM5_LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

build: $(dhrystone_bin)
build-pin: $(dhrystone_pin_bin)
build-gem5: $(dhrystone_gem5_bin)

clean:
	rm -f *.i *.s *.o $(dhrystone_bin) $(dhrystone_pin_bin) $(dhrystone_gem5_bin) dhrystone.hex

run: $(dhrystone_bin)
	./$(dhrystone_bin)
