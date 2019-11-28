#pragma once

#include <iostream>
#include <wtypes.h>
#include <string>
#include "Controller.h"

using namespace std;

int checkFile(char* filename)
{
	FILE* plik;
	fopen_s(&plik, filename, "rb");  /* wa¿ne, by nie tworzyæ pliku, jeœli nie istnieje, tryb "r" (tylko odczyt) */
	if (plik)
	{
		fclose(plik);
		return 0;
	}
	else
	{
		return 1;
	}

}

int checkThreads(char* num)
{
	SYSTEM_INFO sysinfo;
	GetSystemInfo(&sysinfo);
	int numCPU = sysinfo.dwNumberOfProcessors;

	if (num == NULL)
	{
		return numCPU;
	}
	else
	{
		int threadsNumber = atoi(num);
		if ((threadsNumber < 1) || (threadsNumber > 64))
		{
			return numCPU;

		}
		else
		{
			return threadsNumber;
		}
	}
}


int checkMode(char* num)
{
	if (strcmp(num, "0") == 0)
	{
		return true;
	}
	else if (strcmp(num, "1") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}


bool loadParams(int argc, char* argv[]) {
	if (argc == 3|| argc == 4)
	{
		cout << "Prawidlowa liczba argumentow" << endl;

		if ((checkMode(argv[1]) && checkFile(argv[2])) && checkThreads(argv[3]))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		cout << "Nieprawidlowa liczba argumentow" << endl;
		return 0;
	}
}