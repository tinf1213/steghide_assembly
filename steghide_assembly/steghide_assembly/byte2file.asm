include Irvine32.inc
.data 
filename0 BYTE "C:\steghide_assembly\output\Create0.bmp",0

filename11 BYTE "C:\steghide_assembly\output\Create1.txt",0
filename12 BYTE "C:\steghide_assembly\output\Create1.bmp",0
filename13 BYTE "C:\steghide_assembly\output\Create1.jpg",0
filename14 BYTE "C:\steghide_assembly\output\Create1.exe",0
errMsg BYTE "Cannot create file",0dh,0ah,0
fileHandle DWORD ?
bytesWritten BYTE ?;

;showBmpPtr dword 3
;showBmpPtrTemp dword 3
;showBmpLen dword 3
;ft byte 1
.code 
;main PROC 
	;invoke byte2file, showBmpPtr, showBmpLen, ft;
;invoke ExitProcess,0 
;main ENDP 
byte2file proc,
	buffer: DWORD, bufSize: DWORD, fileType: byte, output: DWORD
	;output=0
	.IF output==0
		.IF fileType==2
			INVOKE CreateFile,
			ADDR filename0, ; ptr to filename
			GENERIC_WRITE, ; access mode
			0, ; share mode
			0, ; ptr to security attributes
			CREATE_ALWAYS, ; file creation options
			FILE_ATTRIBUTE_NORMAL, ; file attributes
			0 ; handle to template file
		.ENDIF
	.ENDIF

	;output=1
	.IF output==1
	.IF fileType==1
		INVOKE CreateFile,
		ADDR filename11, ; ptr to filename
		GENERIC_WRITE, ; access mode
		0, ; share mode
		0, ; ptr to security attributes
		CREATE_ALWAYS, ; file creation options
		FILE_ATTRIBUTE_NORMAL, ; file attributes
		0 ; handle to template file
	.ENDIF

	.IF fileType==2
		INVOKE CreateFile,
		ADDR filename12, ; ptr to filename
		GENERIC_WRITE, ; access mode
		0, ; share mode
		0, ; ptr to security attributes
		CREATE_ALWAYS, ; file creation options
		FILE_ATTRIBUTE_NORMAL, ; file attributes
		0 ; handle to template file
	.ENDIF

	.IF fileType==3
		INVOKE CreateFile,
		ADDR filename13, ; ptr to filename
		GENERIC_WRITE, ; access mode
		0, ; share mode
		0, ; ptr to security attributes
		CREATE_ALWAYS, ; file creation options
		FILE_ATTRIBUTE_NORMAL, ; file attributes
		0 ; handle to template file
	.ENDIF

	.IF fileType==4
		INVOKE CreateFile,
		ADDR filename14, ; ptr to filename
		GENERIC_WRITE, ; access mode
		0, ; share mode
		0, ; ptr to security attributes
		CREATE_ALWAYS, ; file creation options
		FILE_ATTRIBUTE_NORMAL, ; file attributes
		0 ; handle to template file
	.ENDIF
	.ENDIF
	mov fileHandle, eax
	.IF eax == INVALID_HANDLE_VALUE
		mov edx,OFFSET errMsg ; Display error message
		call WriteString
		jmp END_FUNC
	.ENDIF
	

	INVOKE WriteFile, ; write text to file
	fileHandle, ; file handle
	buffer, ; buffer pointer
	bufSize, ; number of bytes to write
	ADDR bytesWritten, ; number of bytes written
	0 ; overlapped execution flag

END_FUNC:
	ret
byte2file ENDP
END

