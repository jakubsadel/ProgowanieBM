#pragma once

#include "pch.h"


using namespace std;

class Bitmap
{
public:
	FILE* File;
	FILE* File2;
	unsigned char* Tablica;
	unsigned char* Tablica2;
	int AdresDanych;
	int RozmiarDanych;
	int Szerokosc;
	int szerokoscbajt;
	int Wysokosc;
	int zera;

	~Bitmap();

private:
	void ResztaDanych();

public:
	int WczytajPlik(const char NazwaPliku[50]);

	void PrzepiszDoTablicy2();

	void PrzepiszDoTablicy1();

	void AsmBlurMethod(unsigned int watki);

	void CppBlurMethod(unsigned int watki);

	int ZapiszPlik(const char NazwaPliku[50]);
};