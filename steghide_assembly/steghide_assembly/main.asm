INCLUDE Irvine32.inc
INCLUDE file2byte.inc ; Include the file containing the prototype

.data
filename BYTE "C:\steghide_assembly\steghide_assembly\files\test.bmp", 0
errMsg BYTE "Cannot create file", 0

.code
main PROC
    INVOKE File2Byte, addr filename
    ret
main ENDP

END main
