
; Adres pierwszego elementu tablicy pikseli lewego obrazu przekazywana do rcx
; Adres pierwszego elementu tablicy pikseli prawego obrazu przekazywana do rdx
; Szeroko�� obrazu przekazywana do r8d
; Wysoko�� obrazu przekazywana do r9d
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; Sekcja .data zawiera deklaracje zmiennych potrzebnych do oblicze�: 
; - 0
.data

three REAL8 3.0

.code

generateasm PROC

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; przygotowanie rejestr�w i zmiennych
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	emms										; przygotowanie koprocesora do dzia�a� na warto�ciach zmiennoprzecinkowych

	mov dword ptr [rsp + 18h], r8d				; pobiera i zapisuje szeroko�� z r8
	mov byte ptr [rsp + 28h], 0					; padding ( bmp padding ) 

; if ((width * 3) % 4 != 0)
	imul eax, dword ptr [rsp + 18h], 3			; width * 3
	and eax, 3									; (width * 3) % 4
	cmp eax, 0									; ((width * 3) % 4) != 0
	je falseIf									; skok je�eli padding jest niepotrzebny


falseIf:
	mov r15, 0									; @@@ indeks, kontroluje iterowanie po tablicy w pami�ci @@@ - ustawienie pozycji na 0

; for (int j = 0; j < height; ++j) - heightLoop
; for (int i = 0; i < width; ++i) - widthLoop

	widthLoop:									; p�tla wewn�trzna 



		movzx rax, byte ptr [rcx + r15 + 2]		; zapisanie do rax warto�ci sk�adowej koloru zielonego piksela prawego obrazu ( wype�nia zerami r�nice w pojemno�ci typ�w )
		cvtsi2sd xmm6,rax						;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej



		movzx rax, byte ptr [rcx + r15 + 1]		; zapisanie do rax warto�ci sk�adowej koloru zielonego piksela prawego obrazu ( wype�nia zerami r�nice w pojemno�ci typ�w )
		cvtsi2sd xmm5,rax						;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej

		
		movzx rax, byte ptr [rcx + r15]			; analogicznie do koloru zielonego
		cvtsi2sd xmm4,rax						;konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej



	addsd xmm4,xmm5						;sumowanie warto�ci B z warto�ci� G
	addsd xmm4,xmm6						;sumowanie poprzednio uzyskanej warto�ci z warto�ci� R
	divsd xmm4,three					;dzielenie liczby przez 3 celem uzyskania warto�ci koloru szaro�ci


	cvttsd2si rax,xmm4						;konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
	mov byte ptr[rcx + r15],al				;zapisanie przetworznonego parametru B do tablicy
	mov byte ptr[rcx + r15 + 1],al			;zapisanie przetworzonego parametru G do tablicy
	mov byte ptr[rcx + r15 + 2],al			;zapisanie przetworzonego parametru R do tablicy


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		add r15, 3								; przesuni�cie indeksu tablicy o 3, bo analizowane sa 3 sk�adowe w jednej iteracji 
		dec r8									; dekrementacja szeroko�ci wiersza
		jnz widthLoop							; skok do p�tli wewnetrznej je�eli szeroko�� nie jest zerem
	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	heightLoop:									; p�tla zewn�trzena
		movsxd r8, dword ptr [rsp + 18h]		; r8 <- width, szeroko�� kolejnego wiersza
		movzx eax, byte ptr [rsp + 28h]			; eax <- padding
		add r15, rax							; pozycja w tablicy przesuni�ta o wartos� padding w celu wyr�wnania wiersza 
		dec r9									; dekrementacja wysoko�ci - kolejny wiersz
		jz return								; skok na koniec programu je�eli wysoko�c == 0
		jmp widthLoop							; skok bezwarunkowy do petli wewn�trznej

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

return:
	ret											; powr�t z funkcji do programu g��wnego

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

generateasm endp

end