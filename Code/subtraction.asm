; Member 2 - Hina Naeem
; subtraction.asm
; Computes num1 - num2 by flipping num2 sign and calling AddLarge.

INCLUDE Irvine32.inc

PUBLIC SubtractLarge

AddLarge PROTO

EXTERN num2Sign:BYTE

.code

SubtractLarge PROC
    xor BYTE PTR num2Sign, 1
    call AddLarge
    xor BYTE PTR num2Sign, 1
    ret
SubtractLarge ENDP

END