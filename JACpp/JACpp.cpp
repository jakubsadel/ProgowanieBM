
#include "pch.h"
#include "JACpp.h"

//Funkcja zajmujaca sie przeksztalcenie tablicy z pikselami
void MyProc2(unsigned char* tab, int width, int height)
{
	double value = 0.0;
	double treshold = 150.0;
	const int size = 4 * width * height;		//ustalenie rozmiaru tablicy
	for (int i = 0; i < size; i += 4)
	{

		value = (tab[i] + tab[i + 1] + tab[i + 2]) / 3;

		if (value > treshold)
		{
			tab[i] = static_cast<unsigned char>(255);		
			tab[i + 1] = static_cast<unsigned char>(255);
			tab[i + 2] = static_cast<unsigned char>(255);
		}
		else
		{
			tab[i] = static_cast<unsigned char>(0);		
			tab[i + 1] = static_cast<unsigned char>(0);
			tab[i + 2] = static_cast<unsigned char>(0);
		}

	}
}

