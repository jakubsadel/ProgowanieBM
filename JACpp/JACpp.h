#pragma once

#ifdef JACPP_EXPORTS
#define JACDLL_API __declspec(dllexport)
#else
#define JACDLL_API __declspec(dllimport)
#endif


extern "C" JACDLL_API void MyProc2(unsigned char* tab, int width, int height);

