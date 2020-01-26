// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include "Controller.h"
#include "conio.h"





int main()
{
		SYSTEM_INFO sysinfo;
		GetSystemInfo(&sysinfo);
		int threads = sysinfo.dwNumberOfProcessors;
		cout << "Czy chcesz zmienic liczbe watkow? y/n: ";
		char znak = _getch();
		if (znak == 'y')
		{
			cout << "\nPodaj ilosc watkow: ";
			cin >> threads;
			if (threads < 1)
				threads = 1;
			else if (threads > 64)
				threads = 64;
		}
		else {
			cout << "\n";
		}
		cout << "Ilosc watkow: "<<threads<<"\n";
		Controller* controller = new Controller();
		controller->launch(threads);
		delete controller;
		controller = NULL;

}