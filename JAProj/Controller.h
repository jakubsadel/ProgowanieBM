#pragma once
#include "pch.h"


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

