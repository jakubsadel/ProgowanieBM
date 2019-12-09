#pragma once

#include "pch.h"
#include "Bitmap.h"

class Bajt {
public:

	int  Wartosc;
	char Bity[32];

	int LiczbaBitow; //!Ile bitow ma liczba

	Bajt(int n = 8) //!Konstruktor (n-liczba bitów na liczbê)
	{
		LiczbaBitow = n;
	}

	void Binarnie(void);

	void Dziesietnie(void);

	void Zamien(Bajt a, Bajt b, Bajt c, Bajt d); //!Utworzenie 32-bitowej liczby z bajtow a,b,c i d
	
};