#include <stdio.h>

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
    int steps = collatz(27);

    printf("Number of steps: %d\n", steps);
    return 0;
}