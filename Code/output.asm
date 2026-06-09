
; Urwa Imran | output.asm
; Output and formatting support for the final calculator.
; Prints the shared result array in normal human-readable order.

INCLUDE Irvine32.inc

PUBLIC DisplayResult
PUBLIC RemoveLeadingZeros

EXTERN result:BYTE
EXTERN resultLen:DWORD
EXTERN resultSign:BYTE

.data
    resultMsg BYTE "Result: ", 0
    minusMsg BYTE "-", 0

.code

; RemoveLeadingZeros updates resultLen before printing.
RemoveLeadingZeros PROC USES esi eax
    mov esi, resultLen

    cmp esi, 0
    jne startTrim

    mov resultLen, 1
    mov BYTE PTR result[0], 0
    mov resultSign, 0
    ret

startTrim:
    dec esi

trimLoop:
    cmp esi, 0
    je trimDone

    movzx eax, BYTE PTR result[esi]
    cmp eax, 0
    jne trimDone

    dec esi
    jmp trimLoop

trimDone:
    inc esi
    mov resultLen, esi

    cmp resultLen, 1
    jne trimExit

    cmp BYTE PTR result[0], 0
    jne trimExit

    mov resultSign, 0

trimExit:
    ret
RemoveLeadingZeros ENDP

; DisplayResult prints sign first, then digits from high to low index.
DisplayResult PROC USES esi eax edx
    call RemoveLeadingZeros

    mov edx, OFFSET resultMsg
    call WriteString

    cmp resultSign, 1
    jne skipMinus

    cmp resultLen, 1
    jne printMinus

    cmp BYTE PTR result[0], 0
    je skipMinus

printMinus:
    mov edx, OFFSET minusMsg
    call WriteString

skipMinus:
    mov esi, resultLen
    dec esi

printLoop:
    cmp esi, 0
    jl printDone

    movzx eax, BYTE PTR result[esi]
    add al, '0'
    call WriteChar

    dec esi
    jmp printLoop

printDone:
    call CrlF
    ret
DisplayResult ENDP

END

