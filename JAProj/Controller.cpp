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

void Controller::run()
{
	Bitmap bitmapa;
	bitmapa.WczytajPlik("xd.bmp");
	bitmapa.PrzepiszDoTablicy2();
	if (mode == 0)
	{
		bitmapa.CppBlurMethod(threadsNumber);
		bitmapa.PrzepiszDoTablicy1();
		bitmapa.ZapiszPlik("resultcpp.bmp");
	}
	else
	{
		cout << "brak dll" << endl;
	}
}

