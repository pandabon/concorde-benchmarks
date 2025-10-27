JOBS ?= $(shell nproc 2>/dev/null || echo 1)
GIT ?= git
DEPS_DIR ?= deps
# PREFIX ?= build

BUILD_TARGETS := build/dhrystone \
				 build/coremark \
				 build/libevent \
				 build/memcached

$(BUILD_TARGETS): | init

.PHONY: clean help

init:
	@if git submodule status | grep --quiet '^-'; then \
		$(GIT) submodule init && \
		$(GIT) submodule update --recursive; \
	fi

deinit:
	$(GIT) submodule deinit --all -f

clean: clean/dhrystone clean/coremark

###########################################################
# dhrystone
###########################################################
# params: ITERS, HZ

build/dhrystone:
	cd dhrystone && $(MAKE) build

run/dhrystone: build/dhrystone
	cd dhrystone && $(MAKE) run

clean/dhrystone:
	cd dhrystone && $(MAKE) clean

###########################################################
# coremark
###########################################################
# params: ITERATIONS

build/coremark:
	cd coremark && $(MAKE)

clean/coremark:
	cd dhrystone && $(MAKE) clean

###########################################################
# memcached
###########################################################
build/libevent:
	cd $(DEPS_DIR)/libevent && \
	./autogen.sh && \
	./configure --prefix=$(pwd)/build && \
	make && \
	make install

build/memcached: build/libevent
	cd memcached && \
	./autogen.sh && \
	./configure --with-libevent=$(DEPS_DIR)/libevent/build/ && \
	make

run/memcached: build/memcached
	cd memcached && \
	make test


###########################################################
# dcperf
###########################################################