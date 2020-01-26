
.data

three REAL8 3.0
threshold REAL8 127.0

.code

generateasm PROC

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; przygotowanie rejestrów i zmiennych
; DATA RCX
; WIDTH EDX
; HEIGHT R8D
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	emms										; przygotowanie koprocesora do dzia³añ na wartoœciach zmiennoprzecinkowych

	mov dword ptr [rsp + 18h], edx				; pobiera i zapisuje szerokoœæ 
	mov byte ptr [rsp + 28h], 0					; padding ( bmp padding ) 

; if ((width * 3) % 4 != 0)
	imul eax, dword ptr [rsp + 18h], 3			; width * 3
	and eax, 3									; (width * 3) % 4
	cmp eax, 0									; ((width * 3) % 4) != 0
	je falseIf									; skok je¿eli padding jest niepotrzebny

; padding = 4 - ((width * 3) % 4)
	mov byte ptr [rsp + 28h], 4					; padding = 4
	sub byte ptr [rsp + 28h], al				; padding = 4 - ((width * 3) % 4)

falseIf:
	mov r15, 0									; @@@ indeks, kontroluje iterowanie po tablicy w pamiêci @@@ - ustawienie pozycji na 0


widthLoop:										; pêtla wewnêtrzna 

		movzx rax, byte ptr [rcx + r15 + 2]		; zapisanie do rax wartoœci sk³adowej koloru zielonego piksela prawego obrazu ( wype³nia zerami ró¿nice w pojemnoœci typów )
		cvtsi2sd xmm6,rax						; konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej

		movzx rax, byte ptr [rcx + r15 + 1]		; zapisanie do rax wartoœci sk³adowej koloru zielonego piksela prawego obrazu ( wype³nia zerami ró¿nice w pojemnoœci typów )
		cvtsi2sd xmm5,rax						; konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej
		
		movzx rax, byte ptr [rcx + r15]			; analogicznie do koloru zielonego
		cvtsi2sd xmm4,rax						; konwersja 32-bitowej wartoœci ca³kowitoliczbowej do 64-bitowej wartoœci zmiennoprzecinkowej

		addsd xmm4,xmm5							; sumowanie wartoœci B z wartoœci¹ G
		addsd xmm4,xmm6							; sumowanie poprzednio uzyskanej wartoœci z wartoœci¹ R
		divsd xmm4,three						; dzielenie liczby przez 3 celem uzyskania wartoœci koloru szaroœci

        comisd  xmm4, QWORD PTR threshold		; porówanie otrzymaje wartoœci z wartoœci¹ progowa
        jbe    SHORT conditionLoop				; skok jesli mniejsze lub równe


		cvttsd2si rax,xmm4						; konwersja 64-bitowej wartoœci zmiennoprzecinkowej do 32-bitowej wartoœci ca³kowitoliczbowej
		mov byte ptr[rcx + r15],255				; zapisanie bia³ego jako parametr B do tablicy
		mov byte ptr[rcx + r15 + 1],255			; zapisanie bia³ego jako parametr do tablicy
		mov byte ptr[rcx + r15 + 2],255			; zapisanie bia³ego jako parametr do tablicy
	    jmp     SHORT incrLoop					; skok do przesuniêcia tablicy

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

conditionLoop:									; pêtla warunkowa
		cvttsd2si rax,xmm4						; konwersja 64-bitowej wartoœci zmiennoprzecinkowej do 32-bitowej wartoœci ca³kowitoliczbowej
		mov byte ptr[rcx + r15],0				; zapisanie czarnego jako parametr B do tablicy
		mov byte ptr[rcx + r15 + 1],0			; zapisanie czarnego jako parametr G do tablicy
		mov byte ptr[rcx + r15 + 2],0			; zapisanie czarnego jako parametr R do tablicy

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

incrLoop:										; pêtla incrementuj¹ca
		add r15, 3								; przesuniêcie indeksu tablicy o 3, bo analizowane sa 3 sk³adowe w jednej iteracji 
		dec rdx									; dekrementacja szerokoœci wiersza
		jnz widthLoop							; skok do pêtli wewnetrznej je¿eli szerokoœæ nie jest zerem
	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	heightLoop:									; pêtla zewnêtrzena
		movsxd rdx, dword ptr [rsp + 18h]		; r8 <- width, szerokoœæ kolejnego wiersza
		movzx eax, byte ptr [rsp + 28h]			; eax <- padding
		add r15, rax							; pozycja w tablicy przesuniêta o wartosæ padding w celu wyrównania wiersza 
		dec r8									; dekrementacja wysokoœci - kolejny wiersz
		jz return								; skok na koniec programu je¿eli wysokoœc == 0
		jmp widthLoop							; skok bezwarunkowy do petli wewnêtrznej

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

return:
	ret											; powrót z funkcji do programu g³ównego

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

generateasm endp

end