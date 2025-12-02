branch_storm_c_src = branch_storm.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O1
LDFLAGS ?=

branch_storm_bin = branch_storm
$(branch_storm_bin): $(branch_storm_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(branch_storm_c_src) $(LDFLAGS) -o $(branch_storm_bin)

.PHONY: build run clean

build: $(branch_storm_bin)

run: $(branch_storm_bin)
	./$(branch_storm_bin)

clean:
	rm -f $(branch_storm_bin) *.o