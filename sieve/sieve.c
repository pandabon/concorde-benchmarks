#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define N 10000

int main(int argc, char* argv[]) {
    
    int n = N;

    int* marked = calloc(n, sizeof(int));

    int smallest_non_marked = 2;
    int p, i;
    int found_next = 1;

    while (found_next) {
        p = 2 * smallest_non_marked;
        while (p < n) {
            marked[p] = p;
            p += smallest_non_marked;
        }

        found_next = 0;
        for (i = smallest_non_marked + 1; i < n; i++) {
            if (marked[i] == 0) {
                smallest_non_marked = i;
                found_next = 1;
                break;
            }
        }
    }

    int prime_count = 0;
    for (i = 2; i < n; i++) {
        if (marked[i] == 0) {
            prime_count++;
        }        
    }
    
    free(marked);
    printf("Number of prime numbers below %d: %d\n", n, prime_count);

    return 0;
}
