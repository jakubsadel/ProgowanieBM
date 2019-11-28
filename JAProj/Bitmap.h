#pragma once
#include <vector>
#include <string>

class Bitmap
{
public:
	Bitmap(std::string path);
	void showParams();
private:
	int width;
	int height;
	int size;
	unsigned char* bitmapData;
	unsigned char* bitmapHeader;
};

