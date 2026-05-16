; Member 2 - Hina Naeem
; compare.asm
; Compares two large numbers stored as reversed digit arrays.
; Returns: EAX = 0 (equal), 1 (num1 bigger), 2 (num2 bigger)

INCLUDE Irvine32.inc

PUBLIC CompareNumbers

EXTERN num1:BYTE
EXTERN num2:BYTE
EXTERN num1Len:DWORD
EXTERN num2Len:DWORD

.code

CompareNumbers PROC USES ebx esi

    mov eax, num1Len
    mov ebx, num2Len
    cmp eax, ebx
    jg num1Bigger
    jl num2Bigger

    mov esi, eax
    dec esi

digitCheck:
    cmp esi, 0
    jl equal
    movzx eax, BYTE PTR num1[esi]
    movzx ebx, BYTE PTR num2[esi]
    cmp eax, ebx
    jg num1Bigger
    jl num2Bigger
    dec esi
    jmp digitCheck

equal:
    mov eax, 0
    ret

num1Bigger:
    mov eax, 1
    ret

num2Bigger:
    mov eax, 2
    ret

CompareNumbers ENDP

END