INCLUDE Irvine32.inc

MAX_DIGITS EQU 200

.data
    num1        BYTE MAX_DIGITS DUP(0)
    num2        BYTE MAX_DIGITS DUP(0)
    num1Len     DWORD 0
    num2Len     DWORD 0
    cmpResult   BYTE 0
    prompt1     BYTE "Enter first number: ", 0
    prompt2     BYTE "Enter second number: ", 0

.code

ReadNumber PROC
    push ebx
    push ecx

    mov ecx, 0

readLoop:
    call ReadChar
    cmp al, 13
    je readDone
    cmp al, '0'
    jl readLoop
    cmp al, '9'
    jg readLoop
    sub al, '0'
    mov [esi + ecx], al
    inc ecx
    jmp readLoop

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


main PROC
    mov edx, OFFSET prompt1
    call WriteString
    mov esi, OFFSET num1
    call ReadNumber
    mov num1Len, eax

    mov edx, OFFSET prompt2
    call WriteString
    mov esi, OFFSET num2
    call ReadNumber
    mov num2Len, eax

    exit
main ENDP

END main