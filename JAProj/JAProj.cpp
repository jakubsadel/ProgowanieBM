// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include <iostream>
#include <wtypes.h>
#include <string>

using namespace std;
typedef int(_stdcall* MyProc1)(int, int);
HINSTANCE dllHandle  = LoadLibrary(L"JAAsm.dll");



int sprawdzTryb(char* xd)
{
	if (strcmp(xd, "0") == 0)
	{
		return true;
	}
	else if (strcmp(xd, "1") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}


void pobierzParametry(int argc, char* argv[]) {
	if (argc > 4 || argc < 3||(!sprawdzTryb(argv[1])))
	{
		string argaE = "Nieprawidlowa ilosc argumentow, sprawdz ReadMe.txt";
		throw  argaE;
	}
	if (!((strcmp(argv[1], "0")) || (strcmp(argv[1], "1"))))
	{
		string argtE = "Nieprawidlowy tryb, sprawdz ReadMe.txt";
		throw argtE;
	}
}




int main(int argc, char* argv[])
{
	MyProc1 procedura = (MyProc1)GetProcAddress(dllHandle, "MyProc1");
	try
	{
		pobierzParametry(argc, argv);
	}
	catch (string argaE)
	{
		cout << "Wyjatek: " << argaE;
	}

}

// Uruchomienie programu: Ctrl + F5 lub menu Debugowanie > Uruchom bez debugowania
// Debugowanie programu: F5 lub menu Debugowanie > Rozpocznij debugowanie

