#include "Controller.h"

Controller::Controller(int mode, int threadsNumber, char* fileName)
{
	this->mode = mode;
	this->threadsNumber = threadsNumber;
	this->fileName = fileName;
}

void Controller::showParams()
{
	cout << "Tryb: " << mode << endl;
	cout << "Ilosc watkow: " << threadsNumber << endl;
	cout << "Nazwa pliku wejsciowego: " << fileName << endl;
}

