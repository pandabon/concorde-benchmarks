sieve_c_src = sieve.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O2
LDFLAGS ?=

sieve_bin = sieve
$(sieve_bin): $(sieve_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(sieve_c_src) $(LDFLAGS) -o $(sieve_bin)

.PHONY: build run clean

build: $(sieve_bin)

run: $(sieve_bin)
	./$(sieve_bin)

clean:
	rm -f $(sieve_bin) *.o