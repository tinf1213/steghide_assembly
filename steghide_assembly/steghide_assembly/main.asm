INCLUDE Irvine32.inc
INCLUDE file2byte.inc ; Include the file containing the prototype
INCLUDE encrypt.inc
INCLUDE byte2file.inc
.data
filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp", 0
errMsg BYTE "Cannot create file", 0
file_path BYTE 256 dup (?) 
; 現在讀進來的是 File_path

showBmpPtr dword ?
showBmpPtrTemp dword ?
showBmpLen dword ?
hideFilePtr dword ?
hideFileLen dword ?
fileType byte 2

unHideFile byte 1000 DUP(?);
unhideFileLen dword ?
unHideFileType byte ?

startFrom dword 82h



.code
main PROC
    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    ;mov ecx, LENGTHOF file_path
    ;call WriteString
    INVOKE File2Byte, ADDR file_path
    mov showBmpPtr, eax
    mov showBmpLen, ebx

    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    ;mov ecx, LENGTHOF file_path
    ;call WriteString
    INVOKE File2Byte, ADDR file_path
    mov hideFilePtr, eax
    mov hideFileLen, ebx
    

    ; 這行以下是加密
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke HideTheFile , showBmpPtrTemp, hideFilePtr, showBmpLen, hideFileLen, fileType
    ;;;;;;;;;寫檔加在這裡;;;;;;;;;
    invoke byte2file, showBmpPtr ,showBmpLen, fileType, 0

    ; 到這行是加密
    
    ; 這行以下是解密
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke unHideTheFile , showBmpPtrTemp, OFFSET  unHideFile, showBmpLen, 0

    mov unhideFileLen, eax
    mov unHideFileType, bl
    ; 到這行是解密
    
    invoke byte2file, offset unHideFile, unhideFileLen, unHideFileType, 1;寫檔


    ret
main ENDP

END main