INCLUDE Irvine32.inc
INCLUDE file2byte.inc ; Include the file containing the prototype

.data
filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp", 0
errMsg BYTE "Cannot create file", 0
file_path BYTE 256 dup (?)

.code
main PROC
    mov edx, OFFSET file_path
    mov ecx, LENGTHOF file_path-1
    call ReadString
    ;mov ecx, LENGTHOF file_path
    ;call WriteString
    INVOKE File2Byte, ADDR file_path
    
    ret
main ENDP

END main
