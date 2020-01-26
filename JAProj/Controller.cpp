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

void Controller::launch(int threadsNumber)
{
	string filename = "dana.bmp";

	transformcpp(threadsNumber, filename);
	transformasm(threadsNumber, filename);
}



void Controller::transformcpp(int threadsNumber, string picture)
{

	clock_t czas;

	threads = new thread[threadsNumber];
	bitmap = new Bitmap(picture);
	bitmap->splitInto(threadsNumber);
		

		if ((dll = LoadLibrary("JACpp.dll")) != NULL)
		{
			generatecpp = (funccpp)GetProcAddress(dll, "generatecpp");
			if (generatecpp == NULL)
				cout << "Nie znaleziono funkcji w JACpp.dll!\n";
		}
		else
			cout << "Nie znaleziono JACpp.dll!\n";

		czas = clock();

		for (int i = 0; i < threadsNumber; ++i)
		{
			threads[i] = thread(generatecpp, bitmap->getPartialBitmapData(i), bitmap->getWidth(), bitmap->getPartialHeight(i));
		}


		for (int i = 0; i < threadsNumber; ++i)
		{
			threads[i].join();
		}	

		czas = clock() - czas;
		cout << "CPP: " << float(czas) / CLOCKS_PER_SEC << "\n";


	bitmap->saveToFile("cpp-result.bmp");

	FreeLibrary(dll);
	delete[] this->threads;
	this->threads = NULL;
	delete this->bitmap;
	this->bitmap = NULL;

;
}

void Controller::transformasm(int threadsNumber, string picture)
{

	clock_t czas;

	threads = new thread[threadsNumber];
	bitmap = new Bitmap(picture);
	bitmap->splitInto(threadsNumber);


	if ((dll = LoadLibrary("JAAsm.dll")) != NULL)
	{
		generateasm = (funcasm)GetProcAddress(dll, "generateasm");
		if (generateasm == NULL)
			cout << "Nie znaleziono funkcji w JAAsm.dll!\n";
	}
	else
		cout << "Nie znaleziono  JAAsm.dll!\n";

	czas = clock();

	for (int i = 0; i < threadsNumber; ++i)
	{
		threads[i] = thread(generateasm, bitmap->getPartialBitmapData(i),  bitmap->getWidth(), bitmap->getPartialHeight(i));
	}


	for (int i = 0; i < threadsNumber; ++i)
	{
		threads[i].join();
	}

	czas = clock() - czas;
	cout << "ASM: " << float(czas) / CLOCKS_PER_SEC << "\n";
	bitmap->saveToFile("asm-result.bmp");

	FreeLibrary(dll);
	delete[] this->threads;
	this->threads = NULL;
	delete this->bitmap;
	this->bitmap = NULL;
}


