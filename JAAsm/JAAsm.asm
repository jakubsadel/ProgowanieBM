
.data

three REAL8 3.0
threshold REAL8 127.0

.code

generateasm PROC

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; przygotowanie rejestr�w i zmiennych
; DATA RCX
; WIDTH EDX
; HEIGHT R8D
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	emms										; przygotowanie koprocesora do dzia�a� na warto�ciach zmiennoprzecinkowych

	mov dword ptr [rsp + 18h], edx				; pobiera i zapisuje szeroko�� 
	mov byte ptr [rsp + 28h], 0					; padding ( bmp padding ) 

; if ((width * 3) % 4 != 0)
	imul eax, dword ptr [rsp + 18h], 3			; width * 3
	and eax, 3									; (width * 3) % 4
	cmp eax, 0									; ((width * 3) % 4) != 0
	je falseIf									; skok je�eli padding jest niepotrzebny

; padding = 4 - ((width * 3) % 4)
	mov byte ptr [rsp + 28h], 4					; padding = 4
	sub byte ptr [rsp + 28h], al				; padding = 4 - ((width * 3) % 4)

falseIf:
	mov r15, 0									; @@@ indeks, kontroluje iterowanie po tablicy w pami�ci @@@ - ustawienie pozycji na 0


widthLoop:										; p�tla wewn�trzna 

		movzx rax, byte ptr [rcx + r15 + 2]		; zapisanie do rax warto�ci sk�adowej koloru zielonego piksela prawego obrazu ( wype�nia zerami r�nice w pojemno�ci typ�w )
		cvtsi2sd xmm6,rax						; konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej

		movzx rax, byte ptr [rcx + r15 + 1]		; zapisanie do rax warto�ci sk�adowej koloru zielonego piksela prawego obrazu ( wype�nia zerami r�nice w pojemno�ci typ�w )
		cvtsi2sd xmm5,rax						; konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej
		
		movzx rax, byte ptr [rcx + r15]			; analogicznie do koloru zielonego
		cvtsi2sd xmm4,rax						; konwersja 32-bitowej warto�ci ca�kowitoliczbowej do 64-bitowej warto�ci zmiennoprzecinkowej

		addsd xmm4,xmm5							; sumowanie warto�ci B z warto�ci� G
		addsd xmm4,xmm6							; sumowanie poprzednio uzyskanej warto�ci z warto�ci� R
		divsd xmm4,three						; dzielenie liczby przez 3 celem uzyskania warto�ci koloru szaro�ci

        comisd  xmm4, QWORD PTR threshold		; por�wanie otrzymaje warto�ci z warto�ci� progowa
        jbe    SHORT conditionLoop				; skok jesli mniejsze lub r�wne


		cvttsd2si rax,xmm4						; konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
		mov byte ptr[rcx + r15],255				; zapisanie bia�ego jako parametr B do tablicy
		mov byte ptr[rcx + r15 + 1],255			; zapisanie bia�ego jako parametr do tablicy
		mov byte ptr[rcx + r15 + 2],255			; zapisanie bia�ego jako parametr do tablicy
	    jmp     SHORT incrLoop					; skok do przesuni�cia tablicy

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

conditionLoop:									; p�tla warunkowa
		cvttsd2si rax,xmm4						; konwersja 64-bitowej warto�ci zmiennoprzecinkowej do 32-bitowej warto�ci ca�kowitoliczbowej
		mov byte ptr[rcx + r15],0				; zapisanie czarnego jako parametr B do tablicy
		mov byte ptr[rcx + r15 + 1],0			; zapisanie czarnego jako parametr G do tablicy
		mov byte ptr[rcx + r15 + 2],0			; zapisanie czarnego jako parametr R do tablicy

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

incrLoop:										; p�tla incrementuj�ca
		add r15, 3								; przesuni�cie indeksu tablicy o 3, bo analizowane sa 3 sk�adowe w jednej iteracji 
		dec rdx									; dekrementacja szeroko�ci wiersza
		jnz widthLoop							; skok do p�tli wewnetrznej je�eli szeroko�� nie jest zerem
	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	heightLoop:									; p�tla zewn�trzena
		movsxd rdx, dword ptr [rsp + 18h]		; r8 <- width, szeroko�� kolejnego wiersza
		movzx eax, byte ptr [rsp + 28h]			; eax <- padding
		add r15, rax							; pozycja w tablicy przesuni�ta o wartos� padding w celu wyr�wnania wiersza 
		dec r8									; dekrementacja wysoko�ci - kolejny wiersz
		jz return								; skok na koniec programu je�eli wysoko�c == 0
		jmp widthLoop							; skok bezwarunkowy do petli wewn�trznej

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

return:
	ret											; powr�t z funkcji do programu g��wnego

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

generateasm endp

end