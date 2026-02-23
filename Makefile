JOBS ?= $(shell nproc 2>/dev/null || echo 1)
GIT ?= git
DEPS_DIR ?= $(CURDIR)/deps
BUILD_DIR ?= $(CURDIR)/build
BUILD_DEPS_DIR ?= $(CURDIR)/build-deps

# Build outputs: executables in $(BUILD_DIR); libevent uses a stamp (library only)
BUILD_TARGETS := $(BUILD_DIR)/dhrystone \
                 $(BUILD_DIR)/sieve \
                 $(BUILD_DIR)/towers \
                 $(BUILD_DIR)/branch_storm \
                 $(BUILD_DIR)/collatz \
                 $(BUILD_DIR)/sparse \
                 $(BUILD_DIR)/whetstone \
                 $(BUILD_DIR)/linpack

BUILD_TARGETS_PIN := $(BUILD_DIR)/dhrystone-pin \
                     $(BUILD_DIR)/sieve-pin \
                     $(BUILD_DIR)/towers-pin \
                     $(BUILD_DIR)/branch_storm-pin \
                     $(BUILD_DIR)/collatz-pin \
                     $(BUILD_DIR)/sparse-pin \
                     $(BUILD_DIR)/whetstone-pin \
                     $(BUILD_DIR)/linpack-pin

BUILD_TARGETS_GEM5 := $(BUILD_DIR)/dhrystone-gem5 \
                      $(BUILD_DIR)/sieve-gem5 \
                      $(BUILD_DIR)/towers-gem5 \
                      $(BUILD_DIR)/branch_storm-gem5 \
                      $(BUILD_DIR)/collatz-gem5 \
                      $(BUILD_DIR)/sparse-gem5 \
                      $(BUILD_DIR)/whetstone-gem5 \
                      $(BUILD_DIR)/linpack-gem5

$(BUILD_TARGETS): | init $(BUILD_DIR) $(BUILD_DEPS_DIR)
$(BUILD_TARGETS_PIN): | init $(BUILD_DIR) $(BUILD_DEPS_DIR)
$(BUILD_TARGETS_GEM5): | init $(BUILD_DIR) $(BUILD_DEPS_DIR)

all: $(BUILD_TARGETS)
build/all: $(BUILD_TARGETS)
all-pin: $(BUILD_TARGETS_PIN)
all-gem5: $(BUILD_TARGETS_GEM5)

.PHONY: clean help init deinit all build/all all-pin all-gem5
.PHONY: build/dhrystone run/dhrystone clean/dhrystone
.PHONY: build/coremark clean/coremark
.PHONY: build/libevent build/memcached run/memcached
.PHONY: build/sieve run/sieve clean/sieve
.PHONY: build/towers run/towers clean/towers
.PHONY: build/branch_storm run/branch_storm clean/branch_storm
.PHONY: build/collatz run/collatz clean/collatz
.PHONY: build/sparse run/sparse clean/sparse
.PHONY: build/whetstone run/whetstone clean/whetstone
.PHONY: build/linpack run/linpack clean/linpack

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

clean: clean/dhrystone clean/sieve clean/towers clean/branch_storm clean/collatz clean/sparse clean/whetstone clean/linpack
	rm -rf $(BUILD_DIR) $(BUILD_DEPS_DIR)

###########################################################
# dhrystone
###########################################################
$(BUILD_DIR)/dhrystone: dhrystone/Makefile dhrystone/dhry_1.c dhrystone/dhry_2.c dhrystone/dhry.h
	cd dhrystone && $(MAKE) build
	cp dhrystone/dhrystone $(BUILD_DIR)/

$(BUILD_DIR)/dhrystone-pin: dhrystone/Makefile dhrystone/dhry_1.c dhrystone/dhry_2.c dhrystone/dhry.h
	cd dhrystone && $(MAKE) build-pin
	cp dhrystone/dhrystone-pin $(BUILD_DIR)/

$(BUILD_DIR)/dhrystone-gem5: dhrystone/Makefile dhrystone/dhry_1.c dhrystone/dhry_2.c dhrystone/dhry.h
	cd dhrystone && $(MAKE) build-gem5
	cp dhrystone/dhrystone-gem5 $(BUILD_DIR)/

build/dhrystone: $(BUILD_DIR)/dhrystone

run/dhrystone: | build/dhrystone
	cd dhrystone && $(MAKE) run

clean/dhrystone:
	cd dhrystone && $(MAKE) clean
	rm -f $(BUILD_DIR)/dhrystone $(BUILD_DIR)/dhrystone-pin $(BUILD_DIR)/dhrystone-gem5

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

$(BUILD_DIR)/sieve-pin: sieve/Makefile sieve/sieve.c
	cd sieve && $(MAKE) build-pin
	cp sieve/sieve-pin $(BUILD_DIR)/

$(BUILD_DIR)/sieve-gem5: sieve/Makefile sieve/sieve.c
	cd sieve && $(MAKE) build-gem5
	cp sieve/sieve-gem5 $(BUILD_DIR)/

build/sieve: $(BUILD_DIR)/sieve

run/sieve: | build/sieve
	cd sieve && $(MAKE) run

clean/sieve:
	cd sieve && $(MAKE) clean
	rm -f $(BUILD_DIR)/sieve $(BUILD_DIR)/sieve-pin $(BUILD_DIR)/sieve-gem5

###########################################################
# towers
###########################################################
$(BUILD_DIR)/towers: towers/Makefile towers/towers_main.c
	cd towers && $(MAKE) build
	cp towers/towers $(BUILD_DIR)/

$(BUILD_DIR)/towers-pin: towers/Makefile towers/towers_main.c
	cd towers && $(MAKE) build-pin
	cp towers/towers-pin $(BUILD_DIR)/

$(BUILD_DIR)/towers-gem5: towers/Makefile towers/towers_main.c
	cd towers && $(MAKE) build-gem5
	cp towers/towers-gem5 $(BUILD_DIR)/

build/towers: $(BUILD_DIR)/towers

run/towers: | build/towers
	cd towers && $(MAKE) run

clean/towers:
	cd towers && $(MAKE) clean
	rm -f $(BUILD_DIR)/towers $(BUILD_DIR)/towers-pin $(BUILD_DIR)/towers-gem5

###########################################################
# branch_storm
###########################################################
$(BUILD_DIR)/branch_storm: branch_storm/Makefile branch_storm/branch_storm.c
	cd branch_storm && $(MAKE) build
	cp branch_storm/branch_storm $(BUILD_DIR)/

$(BUILD_DIR)/branch_storm-pin: branch_storm/Makefile branch_storm/branch_storm.c
	cd branch_storm && $(MAKE) build-pin
	cp branch_storm/branch_storm-pin $(BUILD_DIR)/

$(BUILD_DIR)/branch_storm-gem5: branch_storm/Makefile branch_storm/branch_storm.c
	cd branch_storm && $(MAKE) build-gem5
	cp branch_storm/branch_storm-gem5 $(BUILD_DIR)/

build/branch_storm: $(BUILD_DIR)/branch_storm

run/branch_storm: | build/branch_storm
	cd branch_storm && $(MAKE) run

clean/branch_storm:
	cd branch_storm && $(MAKE) clean
	rm -f $(BUILD_DIR)/branch_storm $(BUILD_DIR)/branch_storm-pin $(BUILD_DIR)/branch_storm-gem5

###########################################################
# collatz
###########################################################
$(BUILD_DIR)/collatz: collatz/Makefile collatz/collatz.c
	cd collatz && $(MAKE) build
	cp collatz/collatz $(BUILD_DIR)/

$(BUILD_DIR)/collatz-pin: collatz/Makefile collatz/collatz.c
	cd collatz && $(MAKE) build-pin
	cp collatz/collatz-pin $(BUILD_DIR)/

$(BUILD_DIR)/collatz-gem5: collatz/Makefile collatz/collatz.c
	cd collatz && $(MAKE) build-gem5
	cp collatz/collatz-gem5 $(BUILD_DIR)/

build/collatz: $(BUILD_DIR)/collatz

run/collatz: | build/collatz
	cd collatz && $(MAKE) run

clean/collatz:
	cd collatz && $(MAKE) clean
	rm -f $(BUILD_DIR)/collatz $(BUILD_DIR)/collatz-pin $(BUILD_DIR)/collatz-gem5

###########################################################
# sparse
###########################################################
$(BUILD_DIR)/sparse: sparse/Makefile sparse/sparse.c
	cd sparse && $(MAKE) build
	cp sparse/sparse $(BUILD_DIR)/

$(BUILD_DIR)/sparse-pin: sparse/Makefile sparse/sparse.c
	cd sparse && $(MAKE) build-pin
	cp sparse/sparse-pin $(BUILD_DIR)/

$(BUILD_DIR)/sparse-gem5: sparse/Makefile sparse/sparse.c
	cd sparse && $(MAKE) build-gem5
	cp sparse/sparse-gem5 $(BUILD_DIR)/

build/sparse: $(BUILD_DIR)/sparse

run/sparse: | build/sparse
	cd sparse && $(MAKE) run

clean/sparse:
	cd sparse && $(MAKE) clean
	rm -f $(BUILD_DIR)/sparse $(BUILD_DIR)/sparse-pin $(BUILD_DIR)/sparse-gem5

###########################################################
# whetstone
###########################################################
$(BUILD_DIR)/whetstone: whetstone/Makefile whetstone/whetstone.c
	cd whetstone && $(MAKE) build
	cp whetstone/whetstone $(BUILD_DIR)/

$(BUILD_DIR)/whetstone-pin: whetstone/Makefile whetstone/whetstone.c
	cd whetstone && $(MAKE) build-pin
	cp whetstone/whetstone-pin $(BUILD_DIR)/

$(BUILD_DIR)/whetstone-gem5: whetstone/Makefile whetstone/whetstone.c
	cd whetstone && $(MAKE) build-gem5
	cp whetstone/whetstone-gem5 $(BUILD_DIR)/

build/whetstone: $(BUILD_DIR)/whetstone

run/whetstone: | build/whetstone
	cd whetstone && $(MAKE) run

clean/whetstone:
	cd whetstone && $(MAKE) clean
	rm -f $(BUILD_DIR)/whetstone $(BUILD_DIR)/whetstone-pin $(BUILD_DIR)/whetstone-gem5

###########################################################
# linpack
###########################################################
$(BUILD_DIR)/linpack: linpack/Makefile linpack/linpack.c
	cd linpack && $(MAKE) build
	cp linpack/linpack $(BUILD_DIR)/

$(BUILD_DIR)/linpack-pin: linpack/Makefile linpack/linpack.c
	cd linpack && $(MAKE) build-pin
	cp linpack/linpack-pin $(BUILD_DIR)/

$(BUILD_DIR)/linpack-gem5: linpack/Makefile linpack/linpack.c
	cd linpack && $(MAKE) build-gem5
	cp linpack/linpack-gem5 $(BUILD_DIR)/

build/linpack: $(BUILD_DIR)/linpack

run/linpack: | build/linpack
	cd linpack && $(MAKE) run

clean/linpack:
	cd linpack && $(MAKE) clean
	rm -f $(BUILD_DIR)/linpack $(BUILD_DIR)/linpack-pin $(BUILD_DIR)/linpack-gem5