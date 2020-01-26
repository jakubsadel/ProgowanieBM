#include "JACpp.h"

void generatecpp(unsigned char* data,  int width, int height)
{
	unsigned char pad = 0;		// padding bmp - s³u¿y dostosowaniu do tego, ¿eby liczba pikseli w ka¿dym wierszu by³a podzielna przez 4 
	int index = 0;				// indeks tablicy pikseli

	double value;
	if ((width * 3) % 4 != 0)
	{
		pad = 4 - ((width * 3) % 4); // obliczenie, ile brakuje pikseli, ¿eby wiersz zawsze byl podzielny przez 4
	}

	for (int j = 0; j < height; ++j) // pêtla zewnêtrzna
	{
		for (int i = 0; i < width; ++i) // pêtla wewnêtrzna
		{
			
			value = (data[index + 2] + data[index + 1] + data[index]) / 3;	//obliczanie skali szarosci z sredniej
			if (value > 127)		//sprawdzanie czy pixel jest jasny czy ciemny
			{
				//ustawia na bialy
				data[index + 2] = (unsigned char)(255);
				data[index + 1] = (unsigned char)(255);
				data[index] = (unsigned char)(255);
			}
			else
			{
				//ustawia na czarny
				data[index + 2] = (unsigned char)(0);
				data[index + 1] = (unsigned char)(0);
				data[index] = (unsigned char)(0);
			 }

			index += 3; // przesuniêcie o 3 pozycje w pamiêci, bo w jednej iteracji przetwarzane sa 3 sk³adowe piksela
		}
		index += pad; // wyrównanie wiersza
	}
}
