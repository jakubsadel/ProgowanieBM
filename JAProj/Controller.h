#pragma once
#include "Bitmap.h"
#include <thread>
#include <Windows.h>
#include <iostream>
#include <string>

class Controller
{
public:
	Controller();
	~Controller();
	void launch();
private:
	thread* threads;
	Bitmap* bitmap;


	//typedef void(*funcasm)(unsigned char*, int, int);
	typedef void(*funccpp)(unsigned char*, int, int);
	HMODULE dll;
	//funcasm generateasm;
	funccpp generatecpp;
private:
	string transformcpp(int, string);
};