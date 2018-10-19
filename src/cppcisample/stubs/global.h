// Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
// License: Apache 2.0. See LICENSE file in root directory.
#pragma once

#ifdef _WIN32
  #define CPPCISAMPLE_OS_WIN
  #ifdef _WIN64
    #define CPPCISAMPLE_OS_WIN64
  #else
    #define CPPCISAMPLE_OS_WIN32
  #endif
  #if defined(__MINGW32__) || defined(__MINGW64__)
    #define CPPCISAMPLE_OS_MINGW
    #ifdef __MINGW64__
      #define CPPCISAMPLE_OS_MINGW64
    #else
      #define CPPCISAMPLE_OS_MINGW32
    #endif
  #elif defined(__CYGWIN__) || defined(__CYGWIN32__)
    #define CPPCISAMPLE_OS_CYGWIN
  #endif
#elif __APPLE__
  #include <TargetConditionals.h>
  #if TARGET_IPHONE_SIMULATOR
    #define CPPCISAMPLE_OS_IPHONE
    #define CPPCISAMPLE_OS_IPHONE_SIMULATOR
  #elif TARGET_OS_IPHONE
    #define CPPCISAMPLE_OS_IPHONE
  #elif TARGET_OS_MAC
    #define CPPCISAMPLE_OS_MAC
  #else
    #error "Unknown Apple platform"
  #endif
#elif __ANDROID__
  #define CPPCISAMPLE_OS_ANDROID
#elif __linux__
  #define CPPCISAMPLE_OS_LINUX
#elif __unix__
  #define CPPCISAMPLE_OS_UNIX
#elif defined(_POSIX_VERSION)
  #define CPPCISAMPLE_OS_POSIX
#else
  #error "Unknown compiler"
#endif

#if defined(CPPCISAMPLE_OS_WIN)
  #define CPPCISAMPLE_DECL_EXPORT __declspec(dllexport)
  #define CPPCISAMPLE_DECL_IMPORT __declspec(dllimport)
  #define CPPCISAMPLE_DECL_HIDDEN
#else
  #define CPPCISAMPLE_DECL_EXPORT __attribute__((visibility("default")))
  #define CPPCISAMPLE_DECL_IMPORT __attribute__((visibility("default")))
  #define CPPCISAMPLE_DECL_HIDDEN __attribute__((visibility("hidden")))
#endif

#ifdef DOXYGEN_WORKING
  #define CPPCISAMPLE_API
#else
  #ifdef CPPCISAMPLE_EXPORTS
    #define CPPCISAMPLE_API CPPCISAMPLE_DECL_EXPORT
  #else
    #define CPPCISAMPLE_API CPPCISAMPLE_DECL_IMPORT
  #endif
#endif

#define CPPCISAMPLE_STRINGIFY2(x) #x
#define CPPCISAMPLE_STRINGIFY(x) CPPCISAMPLE_STRINGIFY2(x)

#if (defined(__GXX_EXPERIMENTAL_CXX0X__) || __cplusplus >= 201103L || \
    (defined(_MSC_VER) && _MSC_VER >= 1900))
#define CPPCISAMPLE_LANG_CXX11 1
#endif

#define CPPCISAMPLE_DISABLE_COPY(Class) \
  Class(const Class&) = delete; \
  Class& operator=(const Class&) = delete;

#define CPPCISAMPLE_DISABLE_MOVE(Class) \
  Class(Class&&) = delete; \
  Class& operator=(Class&&) = delete;

#include "cppcisample/stubs/global_config.h"

CPPCISAMPLE_BEGIN_NAMESPACE

template <typename... T>
void UNUSED(T&&...) {}

CPPCISAMPLE_END_NAMESPACE
