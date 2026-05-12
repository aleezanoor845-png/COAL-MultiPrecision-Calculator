INCLUDE Irvine32.inc

.code

main PROC

    mov edx, OFFSET menuMsg
    call WriteString
    call CrlF

    exit

main ENDP

.data
menuMsg BYTE "COAL Multi Precision Calculator",0

END main