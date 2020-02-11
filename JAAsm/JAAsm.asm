
.data


.code

generateasm PROC

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; przygotowanie rejestrów i zmiennych
; DATA RCX
; WIDTH EDX
; HEIGHT R8D
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	emms										; przygotowanie koprocesora do dzia³añ na wartoœciach zmiennoprzecinkowych

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



	mov dword ptr [rsp + 18h], edx				; pobiera i zapisuje szerokoœæ 
	mov byte ptr [rsp + 28h], 0					; padding ( bmp padding ) 

; if ((width * 3) % 4 != 0)
	imul eax, dword ptr [rsp + 18h], 9			; width * 3
	and eax, 9									; (width * 3) % 4
	cmp eax, 0									; ((width * 3) % 4) != 0
	je falseIf									; skok je¿eli padding jest niepotrzebny

; padding = 4 - ((width * 3) % 4)
	mov byte ptr [rsp + 28h], 12					; padding = 4
	sub byte ptr [rsp + 28h], al				; padding = 4 - ((width * 3) % 4)



falseIf:
	mov r15, 0									; @@@ indeks, kontroluje iterowanie po tablicy w pamiêci @@@ - ustawienie pozycji na 0


widthLoop:										; pêtla wewnêtrzna 


		movzx eax, byte ptr[rcx + r15]				 ;Wartoœci koloru niebieskiego 4 kolejnych pikseli
		pinsrd xmm1, eax, 0						 
		movzx eax, byte ptr[rcx + r15+3]
		pinsrd xmm1, eax, 1
		movzx eax, byte ptr[rcx + r15+6]
		pinsrd xmm1, eax, 2
		movzx eax, byte ptr[rcx + r15+9]
		pinsrd xmm1, eax, 3

		movzx eax, byte ptr[rcx + r15+1]			;Wartoœci koloru zielonego 4 kolejnych pikseli
		pinsrd xmm2, eax, 0						
		movzx eax, byte ptr[rcx + r15+4]
		pinsrd xmm2, eax, 1
		movzx eax, byte ptr[rcx + r15+7]
		pinsrd xmm2, eax, 2
		movzx eax, byte ptr[rcx + r15+10]
		pinsrd xmm2, eax, 3				



		movzx eax, byte ptr[rcx + r15+2]			;Wartoœci koloru czerwonego 4 kolejnych pikseli
		pinsrd xmm3, eax, 0							
		movzx eax, byte ptr[rcx + r15+5]
		pinsrd xmm3, eax, 1
		movzx eax, byte ptr[rcx + r15+8]
		pinsrd xmm3, eax, 2
		movzx eax, byte ptr[rcx + r15+11]
		pinsrd xmm3, eax, 3


		paddusb xmm1,xmm2							 ; sumowanie wartoœci B z wartoœci¹ G
		paddusb xmm1,xmm3							 ; sumowanie poprzednio uzyskanej wartoœci z wartoœci¹ R
		

		cmpnltps xmm1, xmm4							 ;porównanie sumy kolorów z wspó³czynikiem zwraca 1 lub 0
		mulps xmm1, xmm5							 ;mno¿enie razy wektor wype³niony 255



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
										


		add r15, 12								; przesuniêcie indeksu tablicy o 3, bo analizowane sa 3 sk³adowe w jednej iteracji 
		sub rdx, 4								; dekrementacja szerokoœci wiersza
		jnz widthLoop							; skok do pêtli wewnetrznej je¿eli szerokoœæ nie jest zerem
	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	heightLoop:									; pêtla zewnêtrzena
		movsxd rdx, dword ptr [rsp + 18h]		; width, szerokoœæ kolejnego wiersza
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