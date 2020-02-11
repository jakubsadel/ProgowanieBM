
.data


.code

generateasm PROC

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; przygotowanie rejestr�w i zmiennych
; DATA RCX
; WIDTH EDX
; HEIGHT R8D
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	emms										; przygotowanie koprocesora do dzia�a� na warto�ciach zmiennoprzecinkowych

	mov		eax, 150							;Wektor z progiem binaryzacji
	pinsrd xmm4, eax, 0							
	pinsrd xmm4, eax, 1
	pinsrd xmm4, eax, 2
	pinsrd xmm4, eax, 3


	mov	eax, 255								;Wektor z mnoznikiem
	pinsrd xmm5, eax, 0						
	pinsrd xmm5, eax, 1
	pinsrd xmm5, eax, 2
	pinsrd xmm5, eax, 3



	mov dword ptr [rsp + 18h], edx				; pobiera i zapisuje szeroko�� 
	mov byte ptr [rsp + 28h], 0					; padding ( bmp padding ) 

; if ((width * 3) % 4 != 0)
	imul eax, dword ptr [rsp + 18h], 9			; width * 3
	and eax, 9									; (width * 3) % 4
	cmp eax, 0									; ((width * 3) % 4) != 0
	je falseIf									; skok je�eli padding jest niepotrzebny

; padding = 4 - ((width * 3) % 4)
	mov byte ptr [rsp + 28h], 12					; padding = 4
	sub byte ptr [rsp + 28h], al				; padding = 4 - ((width * 3) % 4)



falseIf:
	mov r15, 0									; @@@ indeks, kontroluje iterowanie po tablicy w pami�ci @@@ - ustawienie pozycji na 0


widthLoop:										; p�tla wewn�trzna 


		movzx eax, byte ptr[rcx + r15]				 ;Warto�ci koloru niebieskiego 4 kolejnych pikseli
		pinsrd xmm1, eax, 0						 
		movzx eax, byte ptr[rcx + r15+3]
		pinsrd xmm1, eax, 1
		movzx eax, byte ptr[rcx + r15+6]
		pinsrd xmm1, eax, 2
		movzx eax, byte ptr[rcx + r15+9]
		pinsrd xmm1, eax, 3

		movzx eax, byte ptr[rcx + r15+1]			;Warto�ci koloru zielonego 4 kolejnych pikseli
		pinsrd xmm2, eax, 0						
		movzx eax, byte ptr[rcx + r15+4]
		pinsrd xmm2, eax, 1
		movzx eax, byte ptr[rcx + r15+7]
		pinsrd xmm2, eax, 2
		movzx eax, byte ptr[rcx + r15+10]
		pinsrd xmm2, eax, 3				



		movzx eax, byte ptr[rcx + r15+2]			;Warto�ci koloru czerwonego 4 kolejnych pikseli
		pinsrd xmm3, eax, 0							
		movzx eax, byte ptr[rcx + r15+5]
		pinsrd xmm3, eax, 1
		movzx eax, byte ptr[rcx + r15+8]
		pinsrd xmm3, eax, 2
		movzx eax, byte ptr[rcx + r15+11]
		pinsrd xmm3, eax, 3


		paddusb xmm1,xmm2							 ; sumowanie warto�ci B z warto�ci� G
		paddusb xmm1,xmm3							 ; sumowanie poprzednio uzyskanej warto�ci z warto�ci� R
		

		cmpnltps xmm1, xmm4							 ;por�wnanie sumy kolor�w z wsp�czynikiem zwraca 1 lub 0
		mulps xmm1, xmm5							 ;mno�enie razy wektor wype�niony 255



		pextrd eax, xmm1, 0							 ;zaladowanie 0 lub 255
		mov byte ptr[rcx + r15], al				
		mov byte ptr[rcx + r15+1], al
		mov byte ptr[rcx + r15+2], al

		pextrd	eax, xmm1, 1				
		mov	byte ptr[rcx + r15+3], al
		mov	byte ptr[rcx + r15+4], al
		mov	byte ptr[rcx + r15+5], al

		pextrd	eax, xmm1, 2					
		mov	byte ptr[rcx + r15+6], al
		mov	byte ptr[rcx + r15+7], al
		mov	byte ptr[rcx + r15+8], al
		
		pextrd	eax, xmm1, 3					 
		mov	byte ptr[rcx + r15+9], al
		mov	byte ptr[rcx + r15+10], al
		mov	byte ptr[rcx + r15+11], al
										


		add r15, 12								; przesuni�cie indeksu tablicy o 3, bo analizowane sa 3 sk�adowe w jednej iteracji 
		sub rdx, 4								; dekrementacja szeroko�ci wiersza
		jnz widthLoop							; skok do p�tli wewnetrznej je�eli szeroko�� nie jest zerem
	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	heightLoop:									; p�tla zewn�trzena
		movsxd rdx, dword ptr [rsp + 18h]		; width, szeroko�� kolejnego wiersza
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