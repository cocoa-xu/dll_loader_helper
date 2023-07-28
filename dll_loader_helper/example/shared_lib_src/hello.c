#include <stdio.h>
#include "hello_export.h"

#ifdef __cplusplus
extern "C" {
#endif __cplusplus

HELLO_EXPORT int add(int a, int b) {
  return a + b;
}

#ifdef __cplusplus
}
#endif __cplusplus
