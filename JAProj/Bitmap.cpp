#include "Bitmap.h"

Bitmap::Bitmap(string path) :
	bitmapData(NULL),
	bitmapHeader(NULL)
{
	FILE* f;
	const char* c = path.c_str();
	fopen_s(&f, c, "rb");
	bitmapHeader = new unsigned char[54];
	fread(bitmapHeader, sizeof(unsigned char), 54, f);		// nag³ówek bitmapy (54 bity) 

	width = *(int*)&bitmapHeader[18];
	height = *(int*)&bitmapHeader[22];
	size = *(int*)&bitmapHeader[34];						// rozmiar roboczy bitmapy = piksele * 3, bo ka¿dy piksel ma 3 sk³adowe

	bitmapData = new unsigned char[size];					// tablica sk³adowych pikseli
	fread(bitmapData, sizeof(unsigned char), size, f);	// wczytanie danych do tablicy
	fclose(f);
}

Bitmap::~Bitmap()
{
	delete this->bitmapData;
	this->bitmapData = NULL;
	delete this->bitmapHeader;
	this->bitmapHeader = NULL;
	this->partialBitmapData.clear();
}

int Bitmap::getSize()
{
	return this->size;
}

int Bitmap::getWidth()
{
	return this->width;
}

int Bitmap::getHeight()
{
	return this->height;
}

unsigned char* Bitmap::getPartialBitmapData(int index)
{
	return this->partialBitmapData[index];
}

int Bitmap::getPartialHeight(int index)
{
	return this->partialHeight[index];
}

void Bitmap::saveToFile(string path)
{
	FILE* f;
	const char* c = path.c_str();
	fopen_s(&f, c, "wb");
	fwrite(bitmapHeader, sizeof(unsigned char), 54, f);
	fwrite(bitmapData, sizeof(unsigned char), size, f);
	fclose(f);
}

void Bitmap::splitInto(int threadsNumber)
{
	int tmpHeight = (int)(height / threadsNumber);
	partialBitmapData.push_back(bitmapData);
	partialHeight.push_back(height - tmpHeight * (threadsNumber - 1));

	int pad = 0;

	if ((width * 3) % 4 != 0)
	{
		pad = 4 - ((width * 3) % 4);
	}

	for (int i = 1; i < threadsNumber; ++i)
	{
		partialBitmapData.push_back(partialBitmapData[i - 1] + partialHeight[i - 1] * width * 3 + partialHeight[i - 1] * pad); // dzielenie obrazka, ka¿dy w¹tek zaczyna od innego adresu
		partialHeight.push_back(tmpHeight); // dzielenie obszaru obrazka, ka¿dy w¹tek odpowiada za konkretn¹ liczbê wierszy
	}
}