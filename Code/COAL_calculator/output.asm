INCLUDE Irvine32.inc

EXTERN resultMsg:BYTE

.code

DisplayResult PROC

    mov edx, OFFSET resultMsg
    call WriteString
    call CrlF

    ret

DisplayResult ENDP

END