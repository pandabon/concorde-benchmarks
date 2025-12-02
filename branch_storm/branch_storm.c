#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Volatile prevents the compiler from optimizing variables into registers
// or assuming their values are constant.
volatile int sink = 0;
volatile int trigger = 0;

// A simple Linear Congruential Generator for pseudo-randomness
// to defeat the CPU branch predictor.
unsigned int lcg_seed = 0;
inline int get_rand() {
    lcg_seed = lcg_seed * 1103515245 + 12345;
    return (unsigned int)(lcg_seed / 65536) % 32768;
}

// ---------------------------------------------------------
// MACRO MAGIC
// These macros expand recursively to create a massive amount
// of code density consisting almost entirely of branches.
// ---------------------------------------------------------

// The base unit: A conditional check that updates the sink.
// We check (x % n) to vary the taken/not-taken probability.
#define BRANCH_UNIT(n) \
    if (get_rand() % (n + 1)) { \
        sink++; \
    } else { \
        sink--; \
    }

// Recursive expansion 
#define B_2(n)      BRANCH_UNIT(n) BRANCH_UNIT(n)
#define B_4(n)      B_2(n) B_2(n)
#define B_8(n)      B_4(n) B_4(n)
#define B_16(n)     B_8(n) B_8(n)
#define B_32(n)     B_16(n) B_16(n)
#define B_64(n)     B_32(n) B_32(n)
#define B_128(n)    B_64(n) B_64(n)
#define B_256(n)    B_128(n) B_128(n)
#define B_512(n)    B_256(n) B_256(n)
#define B_1024(n)   B_512(n) B_512(n)

// Increase this depth to add more static branches to the binary.
// Be careful: expanding too far will make the compile time massive.
#define RUN_BLOCK B_32(2) B_32(3) B_32(2) B_32(3)

void heavy_branching() {
    // This expands to 4096 individual if-else statements
    RUN_BLOCK
}

int main(int argc, char *argv[]) {
    // Seed based on time to ensure runtime unpredictability
    lcg_seed = time(NULL);
    
    // Optional: Use argument to prevent dead-code elimination 
    // of the entire function block
    if (argc > 1) {
        lcg_seed += atoi(argv[1]);
    }

    printf("Starting Branch Storm...\n");
    clock_t start = clock();

    // Run the loop enough times to stress the CPU
    // 4096 branches * 50,000 iterations = ~200 Million Branches
    for (int i = 0; i < 1000; i++) {
        heavy_branching();
    }

    clock_t end = clock();
    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Finished. Sink value: %d (preventing optimization)\n", sink);
    printf("Time: %f seconds\n", time_spent);

    return 0;
}