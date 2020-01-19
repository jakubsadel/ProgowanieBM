#pragma once
#include <vector>
#include <string>
#include <iostream>


using namespace std;

class Bitmap
{
public:
	Bitmap(string);
	~Bitmap();
	int getSize();
	int getWidth();
	int getHeight();
	unsigned char* getPartialBitmapData(int);
	int getPartialHeight(int);
	void saveToFile(string);
	void splitInto(int);
private:
	int width;
	int height;
	int size;
	unsigned char* bitmapData;
	unsigned char* bitmapHeader;
	vector <unsigned char*> partialBitmapData;
	vector <int> partialHeight;
};