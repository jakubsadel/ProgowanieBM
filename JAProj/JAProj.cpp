// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include "pch.h"


using namespace std;



int main(int argc, char* argv[])
{


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