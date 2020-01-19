// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include <iostream>
#include <windows.h>
#include "Controller.h"


int main()
{
    std::cout << "Hello World!\n";


	Controller* controller = new Controller();
	controller->launch();
	delete controller;
	controller = NULL;


}

