INCLUDE Irvine32.inc
.data
consoleHandle    DWORD ?
filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp",0
fileHandle DWORD ? ; handle to output file
bytesWritten DWORD ? ; number of bytes written
errMsg BYTE "Cannot create file",0dh,0ah,0
Buffer BYTE ?;
;pBuffer PTR BYTE;
nBufsize DWORD 400;
BytesRead BYTE ?;
main EQU start@0
.code
main PROC
	INVOKE CreateFile,
		ADDR filename,				; ptr to filename
		GENERIC_READ,				; access mode
		DO_NOT_SHARE,				; share mode
		NULL,						; ptr to security attributes
		OPEN_EXISTING,				; file creation options
		FILE_ATTRIBUTE_NORMAL,		; file attributes
		0							; handle to template file
	mov fileHandle, eax
	.IF eax == INVALID_HANDLE_VALUE
		mov edx,OFFSET errMsg ; Display error message
		call WriteString
		jmp END_FUNC
	.ENDIF
	INVOKE ReadFile,
		fileHandle,				; handle to file
		offset Buffer,			; ptr to buffer
		nBufsize,				; num bytes to read
		offset BytesRead,		; bytes actually read
		NULL					; NULL (0) for syn mode
	;INVOKE 
END_FUNC:
	exit
main ENDP

END main
