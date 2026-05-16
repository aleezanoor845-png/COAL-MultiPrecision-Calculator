INCLUDE Irvine32.inc

.data

resultMsg BYTE 0dh,0ah
          BYTE "Arithmetic module placeholder executed.",0dh,0ah,0

.code

DisplayResult PROC

    mov edx, OFFSET resultMsg
    call WriteString

    ret

DisplayResult ENDP

END