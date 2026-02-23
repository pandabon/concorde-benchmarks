#include <stdio.h>

/* Trace region markers (instrumented by Pin to enable/disable tracing). */
static volatile int trace_region_marker __attribute__((unused));
void __attribute__((noinline)) start_trace(void) { trace_region_marker = 1; }
void __attribute__((noinline)) end_trace(void)   { trace_region_marker = 0; }

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
    start_trace();
    int steps = collatz(27);
    
    printf("Number of steps: %d\n", steps);
    end_trace();
    return 0;
}