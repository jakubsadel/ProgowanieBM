// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include <iostream>
#include <wtypes.h>
#include <string>
#include "Checker.h"
#include "Controller.h"

using namespace std;
typedef int(_stdcall* MyProc1)(int, int);
HINSTANCE dllHandle  = LoadLibrary(L"JAAsm.dll");




int main(int argc, char* argv[])
{




	MyProc1 procedura = (MyProc1)GetProcAddress(dllHandle, "MyProc1");


	if (!loadParams(argc, argv))
	{
		cout << "Niepoprawne parametry" << endl;
		exit(0);
	}
	else
	{
		cout << "Poprawnie zaladowano dane" << endl;


		int mode = atoi(argv[1]);
		char* fileName = argv[2];
		int threadsNumber = checkThreads(argv[3]);
	



		Controller control(mode, threadsNumber, fileName);
		control.showParams();
	}
		




}

// Uruchomienie programu: Ctrl + F5 lub menu Debugowanie > Uruchom bez debugowania
// Debugowanie programu: F5 lub menu Debugowanie > Rozpocznij debugowanie

