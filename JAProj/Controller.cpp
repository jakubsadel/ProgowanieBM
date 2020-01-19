#include "Controller.h"
Controller::Controller() :

	threads(NULL),
	bitmap(NULL)
{
}

Controller::~Controller()
{

	delete[] this->threads;
	this->threads = NULL;
	delete this->bitmap;
	this->bitmap = NULL;

}

void Controller::launch()
{
	string filename = "data.bmp";

	transformcpp(4, filename);
}



string Controller::transformcpp(int threadsNumber, string picture)
{

	if (threadsNumber < 1)
		threadsNumber = 1;
	else if (threadsNumber > 64)
		threadsNumber = 64;

	threads = new thread[threadsNumber];


	bitmap = new Bitmap(picture);
	bitmap->splitInto(threadsNumber);
		std::cout << "CPP\n";
		if ((dll = LoadLibrary("JACpp.dll")) != NULL)
		{
			generatecpp = (funccpp)GetProcAddress(dll, "generatecpp");
			if (generatecpp == NULL)
				throw new string("Nie znaleziono funkcji w JACpp.dll!");
		}
		else
			throw new string("Nie znaleziono JACpp.dll!");
		for (int i = 0; i < threadsNumber; ++i)
			threads[i] = thread(generatecpp, bitmap->getPartialBitmapData(i), bitmap->getWidth(), bitmap->getPartialHeight(i));


	for (int i = 0; i < threadsNumber; ++i)
		threads[i].join();


	bitmap->saveToFile("cpp-result.bmp");

	FreeLibrary(dll);
	delete[] this->threads;
	this->threads = NULL;
	delete this->bitmap;
	this->bitmap = NULL;


	return "result.bmp";
}