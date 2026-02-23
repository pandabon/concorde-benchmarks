#include <stdio.h>

/* Trace region markers (instrumented by Pin to enable/disable tracing). */
static volatile int trace_region_marker __attribute__((unused));
void __attribute__((noinline)) start_trace(void) { trace_region_marker = 1; }
void __attribute__((noinline)) end_trace(void)   { trace_region_marker = 0; }

// Define the cache line size (usually 64 bytes on x86/ARM)
#define CACHE_LINE_SIZE 64

// The core instruction: A simple increment.
// We then align to the next cache line boundary.
// ".p2align 6" aligns to 2^6 = 64 bytes.
// The NOPs are automatically inserted by the assembler.
#define JUMP_BLOCK \
    __asm__ volatile ( \
        "inc %0 \n\t" \
        ".p2align 6 \n\t" \
        : "+r" (counter) \
    );

// Recursive expansion to create a long chain
#define B_2     JUMP_BLOCK JUMP_BLOCK
#define B_4     B_2 B_2
#define B_8     B_4 B_4
#define B_16    B_8 B_8
#define B_32    B_16 B_16
#define B_64    B_32 B_32
#define B_128   B_64 B_64 
#define B_256   B_128 B_128

void stress_icache() {
    volatile int counter = 0;
    
    // This function body will be huge in bytes, but low in instruction count.
    // Each increment is 64 bytes apart.
    B_16
}

int main() {
    start_trace();
    // We don't need many iterations because the cache misses 
    // will make this incredibly slow.
    for (int i = 0; i < 100; i++) {
        stress_icache();
    }
    end_trace();
    
    return 0;
}