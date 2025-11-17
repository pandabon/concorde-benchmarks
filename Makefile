JOBS ?= $(shell nproc 2>/dev/null || echo 1)
GIT ?= git
DEPS_DIR ?= $(CURDIR)/deps
BUILD_DIR ?= $(CURDIR)/build

# Stamp files to track build completion
BUILD_TARGETS := $(BUILD_DIR)/.dhrystone \
                 $(BUILD_DIR)/.coremark \
                 $(BUILD_DIR)/.libevent \
                 $(BUILD_DIR)/.memcached

$(BUILD_TARGETS): | init $(BUILD_DIR)

.PHONY: clean help init deinit
.PHONY: build/dhrystone run/dhrystone clean/dhrystone
.PHONY: build/coremark clean/coremark
.PHONY: build/libevent build/memcached run/memcached

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

init:
	@if git submodule status | grep --quiet '^-'; then \
		$(GIT) submodule init && \
		$(GIT) submodule update --recursive; \
	fi

deinit:
	$(GIT) submodule deinit --all -f

clean: clean/dhrystone clean/coremark
	rm -rf $(BUILD_DIR)

###########################################################
# dhrystone
###########################################################
$(BUILD_DIR)/.dhrystone:
	cd dhrystone && $(MAKE) build
	@touch $@

build/dhrystone: $(BUILD_DIR)/.dhrystone

run/dhrystone: | build/dhrystone
	cd dhrystone && $(MAKE) run

clean/dhrystone:
	cd dhrystone && $(MAKE) clean
	rm -f $(BUILD_DIR)/.dhrystone

###########################################################
# coremark
###########################################################
$(BUILD_DIR)/.coremark:
	cd coremark && $(MAKE)
	@touch $@

build/coremark: $(BUILD_DIR)/.coremark

run/coremark: build/coremark

clean/coremark:
	cd coremark && $(MAKE) clean
	rm -f $(BUILD_DIR)/.coremark

###########################################################
# memcached
###########################################################
$(BUILD_DIR)/.libevent:
	cd $(DEPS_DIR)/libevent && \
	./autogen.sh && \
	./configure --prefix=$$(pwd)/build && \
	make && \
	make install
	@touch $@

build/libevent: $(BUILD_DIR)/.libevent

$(BUILD_DIR)/.memcached: $(BUILD_DIR)/.libevent
	cd memcached && \
	./autogen.sh && \
	./configure --with-libevent=$(DEPS_DIR)/libevent/build/ && \
	make
	@touch $@

build/memcached: $(BUILD_DIR)/.memcached

run/memcached: | build/memcached
	cd memcached && \
	make test


###########################################################
# dcperf
###########################################################