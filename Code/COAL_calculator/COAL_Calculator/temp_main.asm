INCLUDE Irvine32.inc

CompareNumbers PROTO
AddLarge PROTO
SubtractLarge PROTO

EXTERN num1:BYTE
EXTERN num2:BYTE
EXTERN result:BYTE
EXTERN num1Len:DWORD
EXTERN num2Len:DWORD
EXTERN resultLen:DWORD
EXTERN num1Sign:BYTE
EXTERN num2Sign:BYTE
EXTERN resultSign:BYTE

.data
    prompt1     BYTE "Enter first number: ", 0
    prompt2     BYTE "Enter second number: ", 0
    addMsg      BYTE "Addition Result: ", 0
    subMsg      BYTE "Subtraction Result: ", 0
    cmpEqual    BYTE "Compare: Numbers are EQUAL", 0
    cmpFirst    BYTE "Compare: First number is GREATER", 0
    cmpSecond   BYTE "Compare: Second number is GREATER", 0
    negSign     BYTE "-", 0
    separator   BYTE "========================", 0

.code

ReadNum PROC USES ecx ebx
    mov ecx, 0
    mov BYTE PTR [edi], 0

inputLoop:
    call ReadChar
    cmp al, '-'
    jne checkNum
    mov BYTE PTR [edi], 1
    call WriteChar
    call ReadChar

checkNum:
    cmp al, 13
    je inputDone
    cmp al, '0'
    jl skipIt
    cmp al, '9'
    jg skipIt

    push eax
    call WriteChar
    pop eax

    sub al, '0'
    mov [esi + ecx], al
    inc ecx

skipIt:
    call ReadChar
    jmp inputLoop

inputDone:
    call CrlF

    mov edx, ecx
    dec edx
    push ecx
    xor ecx, ecx

revLoop:
    cmp ecx, edx
    jge revDone
    mov al, [esi + ecx]
    xchg al, [esi + edx]
    mov [esi + ecx], al
    inc ecx
    dec edx
    jmp revLoop

revDone:
    pop eax
    ret
ReadNum ENDP


PrintRes PROC USES esi eax edx
    cmp resultSign, 1
    jne noMinus
    cmp resultLen, 1
    jne printMinus
    cmp BYTE PTR result[0], 0
    je noMinus

printMinus:
    mov edx, OFFSET negSign
    call WriteString

noMinus:
    mov esi, resultLen
    dec esi

printLoop:
    cmp esi, 0
    jl printDone
    movzx eax, BYTE PTR result[esi]
    cmp eax, 0
    jne showIt
    cmp esi, 0
    je showIt
    dec esi
    jmp printLoop

showIt:
    add eax, '0'
    call WriteChar
    dec esi
    jmp printLoop

printDone:
    call CrlF
    ret
PrintRes ENDP


ResetArrays PROC USES ecx edi
    mov ecx, 200
    lea edi, num1
clrLoop1:
    mov BYTE PTR [edi], 0
    inc edi
    loop clrLoop1

    mov ecx, 200
    lea edi, num2
clrLoop2:
    mov BYTE PTR [edi], 0
    inc edi
    loop clrLoop2

    mov ecx, 400
    lea edi, result
clrLoop3:
    mov BYTE PTR [edi], 0
    inc edi
    loop clrLoop3

    mov num1Len, 0
    mov num2Len, 0
    mov resultLen, 0
    mov num1Sign, 0
    mov num2Sign, 0
    mov resultSign, 0
    ret
ResetArrays ENDP


main PROC
    call ResetArrays

    mov edx, OFFSET separator
    call WriteString
    call CrlF

    mov edx, OFFSET prompt1
    call WriteString
    lea esi, num1
    lea edi, num1Sign
    call ReadNum
    mov num1Len, eax

    mov edx, OFFSET prompt2
    call WriteString
    lea esi, num2
    lea edi, num2Sign
    call ReadNum
    mov num2Len, eax

    call CompareNumbers
    cmp eax, 0
    je showEqual
    cmp eax, 1
    je showFirst
    mov edx, OFFSET cmpSecond
    call WriteString
    call CrlF
    jmp doAdd

showEqual:
    mov edx, OFFSET cmpEqual
    call WriteString
    call CrlF
    jmp doAdd

showFirst:
    mov edx, OFFSET cmpFirst
    call WriteString
    call CrlF

doAdd:
    mov edx, OFFSET separator
    call WriteString
    call CrlF
    mov edx, OFFSET addMsg
    call WriteString
    call AddLarge
    call PrintRes

    mov edx, OFFSET separator
    call WriteString
    call CrlF
    mov edx, OFFSET subMsg
    call WriteString
    call SubtractLarge
    call PrintRes

    exit
main ENDP

END main