include Irvine32.inc
.data 
img byte 256 DUP(0A0h);
encrpyt byte 8 DUP(0FFh), 3 DUP(0ABh) ;
decrpyt byte 10 DUP(?);

decrpytFileType byte ?;

.code 
;main PROC 
;xor eax, eax
;xor ebx, ebx
;xor ecx, ecx
;xor edx, edx

;invoke HideTheFile ,OFFSET img, OFFSET encrpyt, LENGTHOF img, LENGTHOF encrpyt, 9
;invoke unHideTheFile ,OFFSET img, OFFSET  decrpyt, LENGTHOF img, 0



;invoke waitmsg
;invoke ExitProcess,0 

;main ENDP 

; send in the pointer of the BMP. Start to hide hideByte from here
encryptOneByte proc USES ecx esi eax,
	showBMP: dword, hideByte: byte

	mov ecx, 4
	mov esi, showBMP
	mov ah, hideByte

	DoTwoAndJumpTwo:

		; push in one bit
		mov al, [esi]
		shr al, 1
		rol ax, 1
		mov [esi], al
		inc esi
		
		; push in one bit
		mov al, [esi]
		shr al, 1
		rol ax, 1
		mov [esi], al
		inc esi

		; jump to two byte after
		add esi, 2
			
	Loop DoTwoAndJumpTwo

	ret
encryptOneByte endp

HideTheFile proc,
    showBMP:dword, HideFile:dword, BMPLen:dword, HideLen: dword, fileType: byte

	mov esi, showBMP

	; encrypt the file type (1 byte)
	invoke encryptOneByte, esi, fileType
	add esi, 16
	
	; encrypt the len of HideFile (4 byte)
	mov ebx, HideLen
	mov ecx, 4
	LenEncrypt:
		push ecx
			rol ebx, 8;
			invoke encryptOneByte, esi, bl
			add esi, 16
			

		pop ecx
	Loop LenEncrypt

	mov edi, HideFIle
	mov ecx, HideLen

	ByteEncrypt:
		push ecx
				invoke encryptOneByte , esi, [edi]
				add esi, 16
				inc edi
		pop ecx
	loop ByteEncrypt



	; 查看 img 內容是否有被更改
	mov ecx, BMPLen
	mov esi, showBMP
	checkImg:
		mov al, [esi] ; 只看 al 就好
		; call crlf
		; call writebin
		inc esi
	loop checkImg


	invoke waitmsg


    ret
HideTheFile endp


; 取出一個 byte 的資料
extractByte proc USES esi eax ecx ebx,
	showBMP: dword
	; edx bring out
	mov esi, showBMP
	xor eax, eax
	mov ecx, 4
	twoBit:
		mov al, [esi]
		mov bl, 1
		and bl, al
		shl ah, 1
		add ah, bl
		inc esi

		mov al, [esi]
		mov bl, 1
		and bl, al
		shl ah, 1
		add ah, bl
		inc esi

		add esi, 2

	Loop twoBit

	mov al, ah
	; call writebin
	; call crlf

	mov dl, ah

	ret
extractByte endp

; 解密檔案
unHideTheFile proc,
    showBMP:dword, HideFile:dword, BMPLen:dword, HideLen: dword

	mov esi, showBMP

	; get hidden file type
	invoke extractByte, esi
	add esi, 16;
	mov decrpytFileType, dl
	mov al, decrpytFileType
	call crlf
	call crlf
	call writebin
	call crlf
	call crlf



	; 取得被隱藏的檔案有多長
	mov ecx, 4
	xor ebx, ebx
	LookHideLen:
		push ecx
		invoke extractByte, esi;
		add esi, 16;
		shr ebx, 8
		mov bl, dl
		pop ecx
	Loop LookHideLen
	mov HideLen, ebx
	mov eax, HideLen
	call crlf
	call crlf
	call writebin
	call crlf
	call crlf


	; 將被隱藏的檔案寫到 HideFile 裡面
	mov edi, HideFile
	mov ecx, HideLen

	LookByte:
		push ecx
		invoke extractByte ,esi;
		add esi, 16
		mov [edi], dl
		inc edi
		pop ecx
	Loop LookByte


	call crlf
	call crlf
	call crlf

	; 輸出看正不正確
	mov esi, HideFile
	mov ecx, Lengthof encrpyt
	checkDecrypt:
		mov al, [esi] ; 只看 al 就好
		call crlf
		call writebin
		call crlf
		inc esi
	loop checkDecrypt

    ret
unHideTheFile endp

END
;END main