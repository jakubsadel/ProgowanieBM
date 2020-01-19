// JAProj.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include <iostream>
#include "Controller.h"


int main()
{
 

		Controller* controller = new Controller();
		controller->launch(1);
		delete controller;
		controller = NULL;

		


}

