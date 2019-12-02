#pragma once
#include <iostream>
#include "Bitmap.h"
using namespace std;


class Controller
{
private:
	int mode;
	int threadsNumber;
	char* fileName;


public:
	Controller(int mode, int threadsNumber, char* filename);
	void showParams();

};

