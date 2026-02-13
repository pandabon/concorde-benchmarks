JOBS ?= $(shell nproc 2>/dev/null || echo 1)
GIT ?= git
DEPS_DIR ?= $(CURDIR)/deps
BUILD_DIR ?= $(CURDIR)/build
BUILD_DEPS_DIR ?= $(CURDIR)/build-deps

# Build outputs: executables in $(BUILD_DIR); libevent uses a stamp (library only)
BUILD_TARGETS := $(BUILD_DIR)/dhrystone \
                 $(BUILD_DIR)/.libevent \
                 $(BUILD_DIR)/sieve \
                 $(BUILD_DIR)/towers \
                 $(BUILD_DIR)/branch_storm \
                 $(BUILD_DIR)/collatz \
                 $(BUILD_DIR)/sparse \
				 $(BUILD_DIR)/whetstone
                #  $(BUILD_DIR)/coremark \
                #  $(BUILD_DIR)/memcached \

$(BUILD_TARGETS): | init $(BUILD_DIR) $(BUILD_DEPS_DIR)

all: $(BUILD_TARGETS)
build/all: $(BUILD_TARGETS)

.PHONY: clean help init deinit all build/all
.PHONY: build/dhrystone run/dhrystone clean/dhrystone
.PHONY: build/coremark clean/coremark
.PHONY: build/libevent build/memcached run/memcached
.PHONY: build/sieve run/sieve clean/sieve
.PHONY: build/towers run/towers clean/towers
.PHONY: build/branch_storm run/branch_storm clean/branch_storm
.PHONY: build/collatz run/collatz clean/collatz
.PHONY: build/sparse run/sparse clean/sparse
.PHONY: build/whetstone run/whetstone clean/whetstone

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DEPS_DIR):
	mkdir -p $(BUILD_DEPS_DIR)

init:
	@if git submodule status | grep --quiet '^-'; then \
		$(GIT) submodule init && \
		$(GIT) submodule update --recursive; \
	fi

deinit:
	$(GIT) submodule deinit --all -f

clean: clean/dhrystone clean/sieve clean/towers clean/branch_storm clean/collatz clean/sparse clean/whetstone
	rm -rf $(BUILD_DIR) $(BUILD_DEPS_DIR)

###########################################################
# dhrystone
###########################################################
$(BUILD_DIR)/dhrystone: dhrystone/Makefile dhrystone/dhry_1.c dhrystone/dhry_2.c dhrystone/dhry.h
	cd dhrystone && $(MAKE) build
	cp dhrystone/dhrystone $(BUILD_DIR)/

build/dhrystone: $(BUILD_DIR)/dhrystone

run/dhrystone: | build/dhrystone
	cd dhrystone && $(MAKE) run

clean/dhrystone:
	cd dhrystone && $(MAKE) clean
	rm -f $(BUILD_DIR)/dhrystone

###########################################################
# coremark
###########################################################
$(BUILD_DIR)/coremark:
	cd coremark && $(MAKE) link
	cp coremark/coremark $(BUILD_DIR)/ 2>/dev/null || cp coremark/coremark.exe $(BUILD_DIR)/coremark

build/coremark: $(BUILD_DIR)/coremark

run/coremark: build/coremark

clean/coremark:
	cd coremark && $(MAKE) clean
	rm -f $(BUILD_DIR)/coremark

###########################################################
# memcached
###########################################################
$(BUILD_DEPS_DIR)/.libevent:
	cd $(DEPS_DIR)/libevent && \
	./autogen.sh && \
	./configure --prefix=$$(pwd)/build && \
	make && \
	make install
	@touch $@

build/libevent: $(BUILD_DEPS_DIR)/.libevent

$(BUILD_DIR)/memcached: $(BUILD_DEPS_DIR)/.libevent
	cd memcached && \
	./autogen.sh && \
	./configure --with-libevent=$(DEPS_DIR)/libevent/build/ && \
	make
	cp memcached/memcached $(BUILD_DIR)/

build/memcached: $(BUILD_DIR)/memcached

run/memcached: | build/memcached
	cd memcached && \
	make test


###########################################################
# sieve
###########################################################
$(BUILD_DIR)/sieve: sieve/Makefile sieve/sieve.c
	cd sieve && $(MAKE) build
	cp sieve/sieve $(BUILD_DIR)/

build/sieve: $(BUILD_DIR)/sieve

run/sieve: | build/sieve
	cd sieve && $(MAKE) run

clean/sieve:
	cd sieve && $(MAKE) clean
	rm -f $(BUILD_DIR)/sieve

###########################################################
# towers
###########################################################
$(BUILD_DIR)/towers: towers/Makefile towers/towers_main.c
	cd towers && $(MAKE) build
	cp towers/towers $(BUILD_DIR)/

build/towers: $(BUILD_DIR)/towers

run/towers: | build/towers
	cd towers && $(MAKE) run

clean/towers:
	cd towers && $(MAKE) clean
	rm -f $(BUILD_DIR)/towers

###########################################################
# branch_storm
###########################################################
$(BUILD_DIR)/branch_storm: branch_storm/Makefile branch_storm/branch_storm.c
	cd branch_storm && $(MAKE) build
	cp branch_storm/branch_storm $(BUILD_DIR)/

build/branch_storm: $(BUILD_DIR)/branch_storm

run/branch_storm: | build/branch_storm
	cd branch_storm && $(MAKE) run

clean/branch_storm:
	cd branch_storm && $(MAKE) clean
	rm -f $(BUILD_DIR)/branch_storm

###########################################################
# collatz
###########################################################
$(BUILD_DIR)/collatz: collatz/Makefile collatz/collatz.c
	cd collatz && $(MAKE) build
	cp collatz/collatz $(BUILD_DIR)/

build/collatz: $(BUILD_DIR)/collatz

run/collatz: | build/collatz
	cd collatz && $(MAKE) run

clean/collatz:
	cd collatz && $(MAKE) clean
	rm -f $(BUILD_DIR)/collatz

###########################################################
# sparse
###########################################################
$(BUILD_DIR)/sparse: sparse/Makefile sparse/sparse.c
	cd sparse && $(MAKE) build
	cp sparse/sparse $(BUILD_DIR)/

build/sparse: $(BUILD_DIR)/sparse

run/sparse: | build/sparse
	cd sparse && $(MAKE) run

clean/sparse:
	cd sparse && $(MAKE) clean
	rm -f $(BUILD_DIR)/sparse

###########################################################
# whetstone
###########################################################
$(BUILD_DIR)/whetstone: whetstone/Makefile whetstone/whetstone.c
	cd whetstone && $(MAKE) build
	cp whetstone/whetstone $(BUILD_DIR)/

build/whetstone: $(BUILD_DIR)/whetstone

run/whetstone: | build/whetstone
	cd whetstone && $(MAKE) run
