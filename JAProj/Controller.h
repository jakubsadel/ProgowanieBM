#pragma once
#include "Bitmap.h"
#include <thread>
#include <Windows.h>
#include <iostream>
#include <string>
#include <ctime>
#include <fstream>

class Controller
{
public:
	Controller();
	~Controller();
	void launch(int);
private:
	thread* threads;
	Bitmap* bitmap;
	Bitmap* bitmap1;

	typedef void(*funcasm)(unsigned char*, int, int);
	typedef void(*funccpp)(unsigned char*, int, int);
	HMODULE dll;
	funcasm generateasm;
	funccpp generatecpp;
private:
	void transformcpp(int, string);
	void transformasm(int, string);
};