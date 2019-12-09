#include "pch.h"



	Bitmap::~Bitmap()
	{
		delete[] Tablica;
		if (this->File != nullptr)
			fclose(File);
	}









	void CallMyDLLC(unsigned char* Tablica, int Szer, int szerokoscbajt, int start, int koniec)
	{
		HINSTANCE hGetProcIDDLL = LoadLibrary("JADLLC.dll");
		FARPROC lpfnGetProcessID = GetProcAddress(HMODULE(hGetProcIDDLL), "Proc2");
		typedef void(__cdecl* pICFUNC)(unsigned char*, int, int, int, int);
		pICFUNC Algorithm;
		Algorithm = pICFUNC(lpfnGetProcessID);

		Algorithm(Tablica, Szer, szerokoscbajt, start, koniec);

	}

	void CallMyDLLAsm(unsigned char* Tablica, int Szer, int szerokoscbajt, int start, int koniec)
	{
		HINSTANCE hGetProcIDDLL = LoadLibrary("JAAsm.dll");
		FARPROC lpfnGetProcessID = GetProcAddress(HMODULE(hGetProcIDDLL), "Proc1");
		typedef void(__cdecl* pICFUNC)(unsigned char*, int, int, int, int);
		pICFUNC Algorithm;
		Algorithm = pICFUNC(lpfnGetProcessID);

		Algorithm(Tablica, Szer, szerokoscbajt, start, koniec);

	}

	void Bitmap::ResztaDanych()	//Oblicza potrzebne póŸniej dane
	{
		zera = (4 - ((this->Szerokosc * 3) % 4)) % 4;
		this->szerokoscbajt = this->Szerokosc * 3 + zera;
		this->Wysokosc = this->RozmiarDanych / this->szerokoscbajt;
	}

	int Bitmap::WczytajPlik(const char NazwaPliku[50])	//Wczytuje mapê bitow¹ o podanej nazwie
	{
		int Znak;

		this->File = fopen(NazwaPliku, "rb");
		if (this->File == nullptr)
			return 0;

		fseek(this->File, 10, SEEK_SET);
		//Utworz 4 jednobajtowe liczby
		Bajt* word1 = new Bajt();
		Bajt* word2 = new Bajt();
		Bajt* word3 = new Bajt();
		Bajt* word4 = new Bajt();

		//!Wczytuj 4 kolejne bajty
		Znak = getc(this->File);
		word1->Wartosc = Znak;
		Znak = getc(this->File);
		word2->Wartosc = Znak;
		Znak = getc(this->File);
		word3->Wartosc = Znak;
		Znak = getc(this->File);
		word4->Wartosc = Znak;

		//!Utworz 32-bitow¹ liczbê z powy¿szych bajtów
		Bajt* Dane = new Bajt(32);
		Dane->Zamien(*word1, *word2, *word3, *word4);
		Dane->Dziesietnie();

		//!Przypisz otrzyman¹ wartoœæ zmiennej adresu danych
		this->AdresDanych = Dane->Wartosc;
		//!Przejdz do 18 bajtu i odczytaj szerokosc
		fseek(this->File, 18, SEEK_SET);

		Znak = getc(this->File);
		word1->Wartosc = Znak;
		Znak = getc(this->File);
		word2->Wartosc = Znak;
		Znak = getc(this->File);
		word3->Wartosc = Znak;
		Znak = getc(this->File);
		word4->Wartosc = Znak;

		Dane->Zamien(*word1, *word2, *word3, *word4);
		Dane->Dziesietnie();

		//!Zapamiêtaj wartoœæ w atrybucie
		this->Szerokosc = Dane->Wartosc;

		//!Przejdz do 34 bajtu i odczytaj dlugosc obszaru danych (4 bajty)
		fseek(this->File, 34, SEEK_SET);

		Znak = getc(this->File);
		word1->Wartosc = Znak;
		Znak = getc(this->File);
		word2->Wartosc = Znak;
		Znak = getc(this->File);
		word3->Wartosc = Znak;
		Znak = getc(this->File);
		word4->Wartosc = Znak;

		//!Utworz 32-bitowa liczbe
		Dane->Zamien(*word1, *word2, *word3, *word4);
		Dane->Dziesietnie();

		//!Zapamiêtaj rozmiar danych
		this->RozmiarDanych = Dane->Wartosc;

		//Za³aduj pozosta³e dane
		ResztaDanych();

		fseek(this->File, this->AdresDanych, SEEK_SET);
		Tablica = new unsigned char[this->RozmiarDanych + this->szerokoscbajt];
		clock_t czas = clock();
		for (int i = 0; i < this->RozmiarDanych; ++i)
		{
			Tablica[i] = getc(this->File);
		}
		std::cout << clock() - czas;
		for (int i = this->RozmiarDanych; i < this->RozmiarDanych + this->szerokoscbajt; ++i)
		{
			Tablica[i] = Tablica[i - this->szerokoscbajt];
		}

		//!Usuñ niepotrzebne ju¿ obiekty
		delete word1;
		delete word2;
		delete word3;
		delete word4;
		delete Dane;

		return(1);
	}

	void Bitmap::PrzepiszDoTablicy2()	//Przygotowuje dane wejœciowe do przetwarzania pliku
	{
		Tablica2 = new unsigned char[(this->Wysokosc + 1) * this->Szerokosc * 4];
		int k = 0;
		for (int i = 0; i <= Wysokosc; ++i)
		{
			int Wys = i * Szerokosc * 4;
			for (int j = 0; j < Szerokosc; ++j)
			{
				int Szer = j * 4;
				Tablica2[Wys + Szer] = Tablica[k++];
				Tablica2[Wys + Szer + 1] = Tablica[k++];
				Tablica2[Wys + Szer + 2] = Tablica[k++];
				Tablica2[Wys + Szer + 3] = 0;
			}
			k += zera;
		}
	}

	void Bitmap::PrzepiszDoTablicy1()	//przygotowuje przetworzone dane do zapisu
	{
		int k = 0;
		for (int i = 0; i <= Wysokosc; ++i)
		{
			int Wys = i * Szerokosc * 4;
			for (int j = 0; j < Szerokosc; ++j)
			{
				int Szer = j * 4;
				Tablica[k++] = Tablica2[Wys + Szer];
				Tablica[k++] = Tablica2[Wys + Szer + 1];
				Tablica[k++] = Tablica2[Wys + Szer + 2];
			}
			k += zera;
		}
	}

	void Bitmap::AsmBlurMethod(unsigned int watki)	//Wywo³uje odpowiedni¹ iloœæ w¹tków funkcji asemblerowej
	{
		int Szer = Szerokosc;
		int Wys = Wysokosc;
		clock_t czas;
		vector<thread> TableThread(watki);
		czas = clock();
		for (unsigned int i = 0; i < watki; ++i)
		{
			TableThread[i] = thread(CallMyDLLAsm, this->Tablica2, Szer, szerokoscbajt, int(float(Wys) / float(watki) * i) / 2 * 2, ((float)Wys / (float)watki) * (i + 1) / 2 * 2);
		}
		for (unsigned int i = 0; i < watki; ++i)
		{
			TableThread[i].join();
		}
		czas = clock() - czas;
		std::cout << "czas " << float(czas) / CLOCKS_PER_SEC << "\n";
	}

	void Bitmap::CppBlurMethod(unsigned int watki)	//Wywo³uje odpowiedni¹ iloœæ w¹tków funkcji cppowej
	{
		int Szer = Szerokosc;
		int Wys = Wysokosc;
		clock_t czas;
		vector<thread> TableThread(watki);
		czas = clock();
		for (unsigned int i = 0; i < watki; ++i)
		{
			TableThread[i] = thread(CallMyDLLC, this->Tablica2, Szer, szerokoscbajt, int(float(Wys) / float(watki) * i) / 2 * 2, ((float)Wys / (float)watki) * (i + 1) / 2 * 2);
		}
		for (unsigned int i = 0; i < watki; ++i)
		{
			TableThread[i].join();
		}
		czas = clock() - czas;
		cout << "czas " << float(czas) / CLOCKS_PER_SEC << "\n";
	}

	int Bitmap::ZapiszPlik(const char NazwaPliku[50])	//!Metoda zapisuje bitmapê 
	{
		int znak;

		File2 = fopen(NazwaPliku, "wb");		//!Utwórz drug¹ bitmapê w trybie binarnym do zapisu
		fseek(File, 0L, SEEK_SET);				//!Wróæ na pocz¹tek pierwszej bitmapy

		for (int i = 0; i < AdresDanych; ++i)	//!Przepisz nag³ówek oryginalnej bitmapy (a¿ do obszaru danych) niczego nie zmieniaj¹c
		{
			znak = getc(File);
			putc(znak, File2);
		}

		for (int i = 0; i < RozmiarDanych; ++i)	//!Przepisuj kolejne bajty obszaru danych zmieniaj¹c ostatni bit ka¿dego koloru
			putc(Tablica[i], File2);

		fclose(File2);

		return (1);
	}
