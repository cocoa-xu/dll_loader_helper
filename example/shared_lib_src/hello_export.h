#if defined (_WIN32)
  #if defined(hello_EXPORTS)
    #define  HELLO_EXPORT __declspec(dllexport)
  #else
    #define  HELLO_EXPORT __declspec(dllimport)
  #endif /* hello_EXPORTS */
#else /* defined (_WIN32) */
 #define HELLO_EXPORT
#endif
