; Member 2 - Hina Naeem
; addition.asm
; Signed addition for large numbers stored as reversed digit arrays.
; Reads num1 and num2, writes answer to result/resultLen/resultSign.

INCLUDE Irvine32.inc

PUBLIC AddLarge

CompareNumbers PROTO
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

PlainAdd PROC USES esi ebx ecx edx eax edi
    mov edi, OFFSET result
    mov ecx, MAX_RESULT_DIGITS
    call ClearArray

    xor esi, esi
    xor ebx, ebx

    mov eax, num1Len
    mov ecx, num2Len
    cmp eax, ecx
    jge lengthSet
    mov eax, ecx

lengthSet:
    mov ecx, eax

digitLoop:
    cmp esi, ecx
    jge leftoverCarry

    xor eax, eax
    xor edx, edx

    cmp esi, num1Len
    jge getNum2Only
    movzx eax, BYTE PTR num1[esi]

getNum2Only:
    cmp esi, num2Len
    jge addCarry
    movzx edx, BYTE PTR num2[esi]

addCarry:
    add eax, edx
    add eax, ebx
    xor ebx, ebx

    cmp eax, 10
    jl saveIt
    sub eax, 10
    mov ebx, 1

saveIt:
    mov BYTE PTR result[esi], al
    inc esi
    jmp digitLoop

leftoverCarry:
    cmp ebx, 0
    je saveFinalLen
    mov BYTE PTR result[esi], bl
    inc esi

saveFinalLen:
    mov resultLen, esi
    ret
PlainAdd ENDP


PlainSub PROC USES esi ebx ecx edx eax edi
    mov edi, OFFSET result
    mov ecx, MAX_RESULT_DIGITS
    call ClearArray

    xor esi, esi
    xor ebx, ebx
    mov ecx, num1Len

borrowLoop:
    cmp esi, ecx
    jge trimAndSave

    movzx eax, BYTE PTR num1[esi]
    xor edx, edx

    cmp esi, num2Len
    jge skipSecond
    movzx edx, BYTE PTR num2[esi]

skipSecond:
    sub eax, edx
    sub eax, ebx
    xor ebx, ebx

    cmp eax, 0
    jge noNeed
    add eax, 10
    mov ebx, 1

noNeed:
    mov BYTE PTR result[esi], al
    inc esi
    jmp borrowLoop

trimAndSave:
    mov resultLen, esi
    dec esi

trimZeros:
    cmp esi, 0
    je keepOne
    cmp BYTE PTR result[esi], 0
    jne stopTrim
    dec esi
    jmp trimZeros

stopTrim:
    inc esi
    mov resultLen, esi
    ret

keepOne:
    mov resultLen, 1
    mov resultSign, 0
    ret
PlainSub ENDP


AddLarge PROC USES eax ebx

    mov al, num1Sign
    mov bl, num2Sign
    cmp al, bl
    jne handleDifferentSigns

    mov resultSign, al
    call PlainAdd
    ret

handleDifferentSigns:
    call CompareNumbers

    cmp eax, 0
    jne notZero
    mov BYTE PTR result[0], 0
    mov resultLen, 1
    mov resultSign, 0
    ret

notZero:
    cmp eax, 1
    jne num2HasBiggerMag

    mov al, num1Sign
    mov resultSign, al
    call PlainSub
    ret

num2HasBiggerMag:
    mov al, num2Sign
    mov resultSign, al

    mov eax, num1Len
    xchg eax, num2Len
    mov num1Len, eax

    mov ecx, 200
    lea esi, num1
    lea edi, num2

swapBytes:
    mov al, [esi]
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al
    inc esi
    inc edi
    loop swapBytes

    call PlainSub

    mov eax, num1Len
    xchg eax, num2Len
    mov num1Len, eax

    mov ecx, 200
    lea esi, num1
    lea edi, num2

swapBack:
    mov al, [esi]
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al
    inc esi
    inc edi
    loop swapBack

    ret

AddLarge ENDP

END