#pragma once
#include <iostream>
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

