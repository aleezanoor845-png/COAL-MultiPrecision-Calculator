INCLUDE Irvine32.inc

MAX_DIGITS EQU 200

.data
    num1        BYTE MAX_DIGITS DUP(0)
    num2        BYTE MAX_DIGITS DUP(0)
    result      BYTE 201 DUP(0)
    num1Len     DWORD 0
    num2Len     DWORD 0
    resultLen   DWORD 0
    num1Sign    BYTE 0
    num2Sign    BYTE 0
    resultSign  BYTE 0
    prompt1     BYTE "Enter first number: ", 0
    prompt2     BYTE "Enter second number: ", 0
    resMsg      BYTE "Result: ", 0
    negSign     BYTE "-", 0

.code

ReadNumber PROC
    push ebx
    push ecx

    mov ecx, 0
    mov BYTE PTR [edi], 0

readLoop:
    call ReadChar
    cmp al, '-'
    jne checkDigit
    mov BYTE PTR [edi], 1
    call WriteChar
    call ReadChar

checkDigit:
    cmp al, 13
    je readDone
    cmp al, '0'
    jl skipChar
    cmp al, '9'
    jg skipChar

    push eax
    call WriteChar
    pop eax

    sub al, '0'
    mov [esi + ecx], al
    inc ecx

skipChar:
    call ReadChar
    jmp checkDigit

readDone:
    call CrlF

    mov edx, ecx
    dec edx
    push ecx
    xor ecx, ecx

reverseLoop:
    cmp ecx, edx
    jge reverseDone
    mov al, [esi + ecx]
    xchg al, [esi + edx]
    mov [esi + ecx], al
    inc ecx
    dec edx
    jmp reverseLoop

reverseDone:
    pop eax
    pop ecx
    pop ebx
    ret
ReadNumber ENDP


; adds two numbers of the same sign (magnitudes only)
; result stored in result[], resultLen updated
AddMagnitudes PROC
    pushad

    xor esi, esi
    xor ebx, ebx

    mov eax, num1Len
    mov ecx, num2Len
    cmp eax, ecx
    jge pickLen
    mov eax, ecx

pickLen:
    mov ecx, eax

addLoop:
    cmp esi, ecx
    jge checkCarry

    xor eax, eax
    xor edx, edx

    cmp esi, num1Len
    jge skipA
    movzx eax, num1[esi]

skipA:
    cmp esi, num2Len
    jge skipB
    movzx edx, num2[esi]

skipB:
    add eax, edx
    add eax, ebx
    xor ebx, ebx

    cmp eax, 10
    jl saveIt
    sub eax, 10
    mov ebx, 1

saveIt:
    mov result[esi], al
    inc esi
    jmp addLoop

checkCarry:
    cmp ebx, 0
    je addFinished
    mov result[esi], bl
    inc esi

addFinished:
    mov resultLen, esi
    popad
    ret
AddMagnitudes ENDP


; subtracts num2 from num1 assuming num1 >= num2 by magnitude
SubMagnitudes PROC
    pushad

    xor esi, esi
    xor ebx, ebx
    mov ecx, num1Len

subLoop:
    cmp esi, ecx
    jge subFinished

    movzx eax, num1[esi]
    xor edx, edx

    cmp esi, num2Len
    jge skipSub
    movzx edx, num2[esi]

skipSub:
    sub eax, edx
    sub eax, ebx
    xor ebx, ebx

    cmp eax, 0
    jge saveDigit
    add eax, 10
    mov ebx, 1

saveDigit:
    mov result[esi], al
    inc esi
    jmp subLoop

subFinished:
    mov resultLen, esi
    popad
    ret
SubMagnitudes ENDP


; compares magnitudes of num1 and num2
; returns 0=equal, 1=num1 bigger, 2=num2 bigger in EAX
CompareMag PROC
    push ebx
    push esi

    mov eax, num1Len
    mov ebx, num2Len
    cmp eax, ebx
    jg mag1bigger
    jl mag2bigger

    mov esi, eax
    dec esi

magLoop:
    cmp esi, 0
    jl magEqual
    movzx eax, num1[esi]
    movzx ebx, num2[esi]
    cmp eax, ebx
    jg mag1bigger
    jl mag2bigger
    dec esi
    jmp magLoop

magEqual:
    mov eax, 0
    jmp magDone

mag1bigger:
    mov eax, 1
    jmp magDone

mag2bigger:
    mov eax, 2

magDone:
    pop esi
    pop ebx
    ret
CompareMag ENDP


PrintResult PROC
    pushad

    mov al, resultSign
    cmp al, 1
    jne skipMinus
    mov edx, OFFSET negSign
    call WriteString

skipMinus:
    mov esi, resultLen
    dec esi

; skip leading zeros but always print the last digit
skipZeros:
    cmp esi, 0
    je printNow
    movzx eax, result[esi]
    cmp eax, 0
    jne printNow
    dec esi
    jmp skipZeros

printNow:
printLoop:
    cmp esi, 0
    jl printDone
    movzx eax, result[esi]
    add eax, '0'
    call WriteChar
    dec esi
    jmp printLoop

printDone:
    call CrlF
    popad
    ret
PrintResult ENDP


main PROC
    mov edx, OFFSET prompt1
    call WriteString
    mov esi, OFFSET num1
    lea edi, num1Sign
    call ReadNumber
    mov num1Len, eax

    mov edx, OFFSET prompt2
    call WriteString
    mov esi, OFFSET num2
    lea edi, num2Sign
    call ReadNumber
    mov num2Len, eax

    mov al, num1Sign
    mov bl, num2Sign
    cmp al, bl
    jne signsDiffer

    ; same sign: add magnitudes, keep the sign
    mov al, num1Sign
    mov resultSign, al
    call AddMagnitudes
    jmp showResult

signsDiffer:
    ; different signs: subtract smaller from larger
    ; result sign = sign of whichever is bigger
    call CompareMag

    cmp eax, 0
    je zeroResult

    cmp eax, 1
    je num1bigger

    ; num2 magnitude is bigger — swap so num1 always holds the bigger
    mov al, num2Sign
    mov resultSign, al

    mov ecx, MAX_DIGITS
    lea esi, num1
    lea edi, num2

swapLoop:
    mov al, [esi]
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al
    inc esi
    inc edi
    loop swapLoop

    mov eax, num1Len
    xchg eax, num2Len
    mov num1Len, eax
    jmp doSub

num1bigger:
    mov al, num1Sign
    mov resultSign, al

doSub:
    call SubMagnitudes
    jmp showResult

zeroResult:
    mov resultSign, 0
    mov result[0], 0
    mov resultLen, 1

showResult:
    mov edx, OFFSET resMsg
    call WriteString
    call PrintResult

    exit
main ENDP

END main