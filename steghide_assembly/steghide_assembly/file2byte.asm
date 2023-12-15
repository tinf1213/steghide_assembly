INCLUDE Irvine32.inc

.data
fileHandle HANDLE ?
Buffer BYTE 1000000 DUP (?)     ; Buffer to read data
BytesRead DWORD ?
errMsg BYTE "Cannot create file", 0

.code
File2Byte PROC,
    path:DWORD
    INVOKE CreateFile,
        path,                      ; ptr to filename
        GENERIC_READ,              ; access mode
        DO_NOT_SHARE,              ; share mode
        NULL,                      ; ptr to security attributes
        OPEN_EXISTING,             ; file creation options
        FILE_ATTRIBUTE_NORMAL,     ; file attributes
        NULL                       ; handle to template file
    mov fileHandle, eax

    .IF fileHandle == INVALID_HANDLE_VALUE
        mov edx,OFFSET errMsg ; Display error message
		call WriteString
		jmp END_FUNC
    .ENDIF

    INVOKE ReadFile,
        fileHandle,               ; handle to file
        ADDR Buffer,              ; ptr to buffer
        Lengthof Buffer,                      ; num bytes to read
        ADDR BytesRead,           ; bytes actually read
        NULL                      ; NULL (0) for synchronous mode

    
END_FUNC:
    INVOKE CloseHandle, fileHandle
    mov eax, Offset Buffer
    mov ebx, BytesRead
    ret
File2Byte ENDP
END