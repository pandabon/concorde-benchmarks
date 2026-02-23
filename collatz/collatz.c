#include <stdio.h>

#ifdef PIN
static volatile int trace_region_marker __attribute__((unused));
void __attribute__((noinline)) start_trace(void) { trace_region_marker = 1; }
void __attribute__((noinline)) end_trace(void)   { trace_region_marker = 0; }
#endif

#ifdef GEM5
#include "gem5/m5ops.h"
#endif

/* Does collatz starting from n,
   returns # of steps to get to
   1 -> 4 -> 2 -> 1 loop. */
int collatz(int n) {
    int steps = 0;
    while (n != 1) {
        if (n % 2 == 0) {
            n = n >> 1;
        } else {
            n = 3 * n + 1;
        }
        steps++;
    }
    return steps;
}

int main(int argc, char* argv[]) {
#ifdef PIN
    start_trace();
#endif
#ifdef GEM5
    m5_work_begin(0,0);
#endif
    int steps = collatz(27);
    
    printf("Number of steps: %d\n", steps);
#ifdef GEM5
    m5_work_end(0,0);
#endif
#ifdef PIN
    end_trace();
#endif
    return 0;
}