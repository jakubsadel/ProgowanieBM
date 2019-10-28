#include "Bitmap.h"

Bitmap::Bitmap(std::string path) :
	bitmapData(NULL),
	bitmapHeader(NULL)
{
	FILE* f;
	fopen_s(&f,path.data(), "rb");
	bitmapHeader = new unsigned char[54];
	fread(bitmapHeader, sizeof(unsigned char), 54, f);		// nag³ówek bitmapy (54 bity) 

	width = *(int*)&bitmapHeader[18];
	height = *(int*)&bitmapHeader[22];
	size = *(int*)&bitmapHeader[34];						// rozmiar roboczy bitmapy = piksele * 3, bo ka¿dy piksel ma 3 sk³adowe

	bitmapData = new unsigned char[size];					// tablica sk³adowych pikseli
	fread(bitmapData, sizeof(unsigned char), size, f);	// wczytanie danych do tablicy
	fclose(f);
}