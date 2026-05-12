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
    msg_equal   BYTE "Numbers are EQUAL", 0
    msg_greater BYTE "First number is GREATER", 0
    msg_lesser  BYTE "Second number is GREATER", 0


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
   push eax
    add al, '0'
    call WriteChar        ; echo the digit to screen
    pop eax
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

CompareNumbers PROC
    pushad

    mov eax, num1Len
    mov ebx, num2Len

    cmp eax, ebx
    jg num1wins
    jl num2wins

    mov esi, eax
    dec esi

digitLoop:
    cmp esi, 0
    jl theyreEqual
    movzx eax, num1[esi]
    movzx ebx, num2[esi]
    cmp eax, ebx
    jg num1wins
    jl num2wins
    dec esi
    jmp digitLoop

theyreEqual:
    mov cmpResult, 0
    jmp compareDone

num1wins:
    mov cmpResult, 1
    jmp compareDone

num2wins:
    mov cmpResult, 2

compareDone:
    popad
    ret
CompareNumbers ENDP

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

    call CompareNumbers

    cmp cmpResult, 0
    je showEqual
    cmp cmpResult, 1
    je showGreater

    mov edx, OFFSET msg_lesser
    call WriteString
    call CrlF
    jmp done

showEqual:
    mov edx, OFFSET msg_equal
    call WriteString
    call CrlF
    jmp done

showGreater:
    mov edx, OFFSET msg_greater
    call WriteString
    call CrlF

done:
    exit
main ENDP

END main