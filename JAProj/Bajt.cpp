#include "Bajt.h"


	void Bajt::Binarnie(void) //!Zamiana atrybutu na wartoœæ binarn¹
	{
		int W;
		int l = 0;
		W = this->Wartosc;

		do
		{
			this->Bity[this->LiczbaBitow - l - 1] = 48 + (W % 2);
			W /= 2;
			l++;
		} while (l != this->LiczbaBitow);
		return;
	}

	void Bajt::Dziesietnie(void) //!Zamiana wartoœci atrybutu na system dziesiêtny
	{
		unsigned long val = 1;
		this->Wartosc = 0;

		for (int l = 0; l < this->LiczbaBitow; l++)
		{
			if (this->Bity[this->LiczbaBitow - l - 1] == '1')
				this->Wartosc += val;
			val *= 2;
		}
		return;
	}

	void Bajt::Zamien(Bajt a, Bajt b, Bajt c, Bajt d) //!Utworzenie 32-bitowej liczby z bajtow a,b,c i d
	{
		a.Binarnie();
		b.Binarnie();
		c.Binarnie();
		d.Binarnie();

		for (int i = 0; i < 8; i++)
		{
			this->Bity[i] = d.Bity[i];
			this->Bity[i + 8] = c.Bity[i];
			this->Bity[i + 16] = b.Bity[i];
			this->Bity[i + 24] = a.Bity[i];
		}
		return;
	}
