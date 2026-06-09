INCLUDE Irvine32.inc

PUBLIC inputBuffer
PUBLIC num1, num2, result
PUBLIC num1Len, num2Len, resultLen
PUBLIC num1Sign, num2Sign, resultSign
PUBLIC ClearArray
PUBLIC StringToArray

MAX_DIGITS EQU 200
MAX_RESULT_DIGITS EQU 400

.data
    inputBuffer BYTE 210 DUP(0)
    num1        BYTE MAX_DIGITS DUP(0)
    num2        BYTE MAX_DIGITS DUP(0)
    result      BYTE MAX_RESULT_DIGITS DUP(0)
    num1Len     DWORD 0
    num2Len     DWORD 0
    resultLen   DWORD 0
    num1Sign    BYTE 0
    num2Sign    BYTE 0
    resultSign  BYTE 0

.code

ClearArray PROC USES edi ecx eax
    mov al, 0
clearLoop:
    cmp ecx, 0
    je clearDone
    mov [edi], al
    inc edi
    dec ecx
    jmp clearLoop
clearDone:
    ret
ClearArray ENDP

StringToArray PROC
    ret
StringToArray ENDP

END