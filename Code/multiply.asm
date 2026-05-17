; ------------------------------------------------------------
; Ayesha Khan - Multiplication Module
; Source file: multiply.asm
; This module multiplies two reversed digit arrays and stores
; the product in the shared result array.
; ------------------------------------------------------------

INCLUDE Irvine32.inc

PUBLIC MultiplyByDigit
PUBLIC AddPartialResult
PUBLIC MultiplyLarge

ClearArray PROTO

EXTERN num1:BYTE
EXTERN num2:BYTE
EXTERN result:BYTE

EXTERN num1Len:DWORD
EXTERN num2Len:DWORD
EXTERN resultLen:DWORD

EXTERN num1Sign:BYTE
EXTERN num2Sign:BYTE
EXTERN resultSign:BYTE

MAX_RESULT_DIGITS EQU 400

.code

; MultiplyByDigit is available for single digit multiplication checks.
; Input: AL = digit from num1, BL = digit from num2, BH = carry
; Output: AL = result digit, BH = new carry
MultiplyByDigit PROC USES ecx edx
    movzx eax, al
    movzx edx, bl
    mul edx

    movzx edx, bh
    add eax, edx

    xor edx, edx
    mov ecx, 10
    div ecx

    mov bh, al
    mov al, dl
    ret
MultiplyByDigit ENDP

; AddPartialResult is available for partial product checks.
; Input: ECX = result index, AL = digit to add, BH = carry
; Output: result[ECX] updated, BH = new carry
AddPartialResult PROC USES eax edx ebp
    movzx eax, al
    movzx edx, BYTE PTR result[ecx]
    add eax, edx

    movzx edx, bh
    add eax, edx

    xor edx, edx
    mov ebp, 10
    div ebp

    mov BYTE PTR result[ecx], dl
    mov bh, al
    ret
AddPartialResult ENDP

; IsZeroInput returns EAX = 1 when either input number is zero.
IsZeroInput PROC
    cmp num1Len, 1
    jne checkNum2

    cmp BYTE PTR num1[0], 0
    je inputIsZero

checkNum2:
    cmp num2Len, 1
    jne inputNotZero

    cmp BYTE PTR num2[0], 0
    je inputIsZero

inputNotZero:
    mov eax, 0
    ret

inputIsZero:
    mov eax, 1
    ret
IsZeroInput ENDP

; TrimMultiplyResult fixes resultLen after multiplication.
TrimMultiplyResult PROC USES esi eax
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
TrimMultiplyResult ENDP

; MultiplyLarge uses the standard long multiplication method.
; Every product is added at index i + j because arrays are reversed.
MultiplyLarge PROC USES esi edi ebx ecx edx ebp eax
    mov edi, OFFSET result
    mov ecx, MAX_RESULT_DIGITS
    call ClearArray

    call IsZeroInput
    cmp eax, 1
    jne continueMultiply

    mov BYTE PTR result[0], 0
    mov resultLen, 1
    mov resultSign, 0
    ret

continueMultiply:
    mov al, num1Sign
    xor al, BYTE PTR num2Sign
    mov resultSign, al

    xor esi, esi        ; i index for num1

outerLoop:
    cmp esi, num1Len
    jae multiplyDone

    xor edi, edi        ; j index for num2
    xor ebx, ebx        ; carry

innerLoop:
    cmp edi, num2Len
    jae carryLoop

    movzx eax, BYTE PTR num1[esi]
    movzx edx, BYTE PTR num2[edi]
    mul edx             ; EAX = num1[i] * num2[j]

    mov ecx, esi
    add ecx, edi        ; result index = i + j

    movzx edx, BYTE PTR result[ecx]
    add eax, edx
    add eax, ebx

    xor edx, edx
    mov ebp, 10
    div ebp             ; EAX = carry, EDX = digit

    mov BYTE PTR result[ecx], dl
    mov ebx, eax

    inc edi
    jmp innerLoop

carryLoop:
    cmp ebx, 0
    je nextOuter

    mov ecx, esi
    add ecx, edi

    movzx eax, BYTE PTR result[ecx]
    add eax, ebx

    xor edx, edx
    mov ebp, 10
    div ebp

    mov BYTE PTR result[ecx], dl
    mov ebx, eax

    inc edi
    jmp carryLoop

nextOuter:
    inc esi
    jmp outerLoop

multiplyDone:
    mov eax, num1Len
    add eax, num2Len
    mov resultLen, eax

    call TrimMultiplyResult
    ret
MultiplyLarge ENDP

END
