collatz_c_src = collatz.c 

HOST_OPTS = -std=gnu99 -DPREALLOCATE=0 -DHOST_DEBUG=0
CC ?= gcc
CFLAGS ?= -O1
LDFLAGS ?=

collatz_bin = collatz
$(collatz_bin): $(collatz_c_src)
	$(CC) $(CFLAGS) $(HOST_OPTS) $(collatz_c_src) $(LDFLAGS) -o $(collatz_bin)

.PHONY: build run clean

build: $(collatz_bin)

run: $(collatz_bin)
	./$(collatz_bin)

clean:
	rm -f $(collatz_bin) *.o