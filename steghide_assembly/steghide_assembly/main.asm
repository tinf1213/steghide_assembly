INCLUDE Irvine32.inc
INCLUDE file2byte.inc ; Include the file containing the prototype
INCLUDE encrypt.inc
INCLUDE byte2file.inc
.data

buffer_showBmp BYTE 1000000 dup(?)
buffer_hideFile BYTE 1000000 dup(?)

filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp", 0
errMsg BYTE "Cannot create file", 0
file_path BYTE 256 dup (?) 
; 現在讀進來的是 File_path

showBmpPtr dword ?
showBmpPtrTemp dword ?
showBmpLen dword ?
hideFilePtr dword ?
hideFileLen dword ?
fileType byte ?
lastChar byte ?
unHideFile byte 1000000 DUP(?);
unhideFileLen dword ?
unHideFileType byte ?
;
inputBuffer BYTE 256 DUP(?) ;Used to store user input
prompt BYTE "Enter 'e' to encrypt/'d' to decrypt/'h' to look over more info: ", 0
errorMsg BYTE "Invalid input. Please enter 'e' or 'd'.", 0
encryptMsg BYTE "Enter the path of the image file: ", 0
textMsg BYTE "Enter the path of the text file to hide: ", 0
decryptMsg BYTE "Enter the path of the encrypted image file: ", 0

info1 BYTE "introduce:",13,10,0
introinfo BYTE "    this is our assembly language final project",13,10,0
info2 BYTE "creator:",13,10,0
creatorinfo BYTE "    111403550",13,10,
         "    111403552",13,10,
         "    111403059",13,10,
         "    111403516",13,10,0
info3 BYTE "explantion of the instruction:",13,10,0
einfo BYTE "    choose letter e to hide a file into an image",13,10, 0
dinfo BYTE "    choose letter d to acquire the hidden file from the encrypted image",13,10,13,10, 0
;
startFrom dword 82h



.code
main PROC
begin:
    mov edx, OFFSET prompt
    call WriteString

    ; Wait for user input
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString

    ; Check user input
    mov al, [inputBuffer]
    cmp al, 'e'
    je  encryptFile
    cmp al, 'd'
    je  decryptFile
    cmp al, 'h'
    je  information
    jmp invalidInput

information:
    mov edx, OFFSET info1
    call WriteString
    mov edx, OFFSET introinfo
    call WriteString
    mov edx, OFFSET info2
    call WriteString
    mov edx, OFFSET creatorinfo
    call WriteString
    mov edx, OFFSET info3
    call WriteString
    mov edx, OFFSET einfo
    call WriteString
    mov edx, OFFSET dinfo
    call WriteString
    jmp begin

encryptFile:
    mov edx, OFFSET encryptMsg
    call WriteString
    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    INVOKE File2Byte, ADDR file_path
    mov esi, eax
    mov ecx, ebx
    mov showBmpLen, ebx
    mov edi, OFFSET buffer_showBmp
    rep movsb
    mov showBmpPtr, OFFSET buffer_showBmp
    mov edx, OFFSET textMsg
    call WriteString
    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    lea ebx, file_path
    add ebx, eax
    dec ebx
    movzx eax, byte ptr [ebx]
    mov lastChar, al 
    .IF lastChar=='t'
        mov fileType, 1
    .ENDIF
    .IF lastChar=='p'
        mov fileType, 2
    .ENDIF
    .IF lastChar=='g'
        mov fileType, 3
    .ENDIF
    .IF lastChar=='e'
        mov fileType, 4
    .ENDIF
    INVOKE File2Byte, ADDR file_path
    mov esi, eax
    mov ecx, ebx
    mov hideFileLen, ebx
    mov edi, OFFSET buffer_hideFile
    rep movsb
    mov hideFilePtr, OFFSET buffer_hideFile

    ; 這行以下是加密
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke HideTheFile , showBmpPtrTemp, hideFilePtr, showBmpLen, hideFileLen, fileType
    ; 到這行是加密
    invoke byte2file, showBmpPtr ,showBmpLen, fileType, 0
    jmp exitProgram

decryptFile:
    mov edx, OFFSET decryptMsg
    call WriteString
    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    INVOKE File2Byte, ADDR file_path
    mov esi, eax
    mov ecx, ebx
    mov showBmpLen, ebx
    mov edi, OFFSET buffer_showBmp
    rep movsb
    mov showBmpPtr, OFFSET buffer_showBmp
     ; 這行以下是解密
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke unHideTheFile , showBmpPtrTemp, OFFSET  unHideFile, showBmpLen, 0

    mov unhideFileLen, eax
    mov unHideFileType, bl
    ; 到這行是解密
    invoke byte2file, offset unHideFile, unhideFileLen, unHideFileType, 1
    jmp exitProgram

invalidInput:
    mov edx, OFFSET errorMsg
    call WriteString
    jmp exitProgram

exitProgram:
    ; Your program exit code here
    exit

    ret
main ENDP

END main