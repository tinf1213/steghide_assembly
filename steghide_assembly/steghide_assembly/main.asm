INCLUDE Irvine32.inc
INCLUDE file2byte.inc ; Include the file containing the prototype
INCLUDE encrypt.inc
INCLUDE byte2file.inc
.data

buffer_showBmp BYTE 10000 dup(?)
buffer_hideFile BYTE 10000 dup(?)

filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp", 0
errMsg BYTE "Cannot create file", 0
file_path BYTE 256 dup (?) 
; �{�bŪ�i�Ӫ��O File_path

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
    mov esi, eax
    mov ecx, ebx
    mov edi, OFFSET buffer_showBmp
    rep movsb

    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    ;mov ecx, LENGTHOF file_path
    ;call WriteString
    INVOKE File2Byte, ADDR file_path
    mov esi, eax
    mov ecx, ebx
    mov edi, OFFSET buffer_hideFile
    rep movsb
    

    ; �o��H�U�O�[�K
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke HideTheFile , showBmpPtrTemp, hideFilePtr, showBmpLen, hideFileLen, fileType
    ;;;;;;;;;�g�ɥ[�b�o��;;;;;;;;;
    invoke byte2file, showBmpPtr ,showBmpLen, fileType, 0

    ; ��o��O�[�K
    
    ; �o��H�U�O�ѱK
    mov eax, showBmpPtr
    add eax, startFrom
    mov showBmpPtrTemp, eax

    invoke unHideTheFile , showBmpPtrTemp, OFFSET  unHideFile, showBmpLen, 0

    mov unhideFileLen, eax
    mov unHideFileType, bl
    ; ��o��O�ѱK
    
    invoke byte2file, offset unHideFile, unhideFileLen, unHideFileType, 1;�g��


    ret
main ENDP

END main