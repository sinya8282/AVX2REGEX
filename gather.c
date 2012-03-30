#include <stdio.h>

typedef unsigned char element_t;
#define bin(a, b) Mtable[b * 256 + a]
#define Msize 6

int matching(element_t *, int, element_t *);

int main()
{
  /* syntactic monoid M */
  char* Mmap[Msize] = {
    "0"    // 0, absorbing element
    "e",   // 1, identity element
    "a",   // 2
    "b",   // 3
    "aa",  // 4
    "ab",  // 5
  };
  const element_t Maccept = 3;
  const element_t Mzero   = 0; // absorbing element
  const element_t Mone    = 1; // identity element

  // for all x in M, x * 0 = 0
  static element_t Mtable[65536];

  // a * a = aa
  bin(2, 2) = 4;
  // a * aa = aa * a = a
  bin(2, 4) = bin(4, 2) = 2;
  // a * b = ab
  bin(2, 3) = 5;
  // a * ab = b
  bin(2, 5) = 3;
  // aa * b = b
  bin(4, 3) = 3;
  // aa * aa = aa
  bin(4, 4) = 4;
  // aa * ab = ab
  bin(4, 5) = 5;
  // for all x in M, x * e = x
  element_t i;
  for (i = 0; i < Msize; i++) {
    bin(i, Mone) = bin(Mone, i) = i;
  }

  // aa * a^14 * b (can be modified)
  static element_t elements[16] = {
    4, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 3
  };

  element_t result = matching(elements, 16, Mtable);

  printf("result: %d -> ", result);
  if (result == Maccept) {
    puts("accept!");
  } else {
    puts("reject!");
  }
  return 0;
}
