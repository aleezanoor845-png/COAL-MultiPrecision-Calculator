; ============================================
; Member 1: Aleeza Noor
; Module: Storage
; File: storage.asm
; Purpose: Store numbers as reversed digit arrays
; ============================================

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

    num1 BYTE MAX_DIGITS DUP(0)
    num2 BYTE MAX_DIGITS DUP(0)
    result BYTE MAX_RESULT_DIGITS DUP(0)

    num1Len DWORD 0
    num2Len DWORD 0
    resultLen DWORD 0

    ; Sign rule:
    ; 0 = positive
    ; 1 = negative
    num1Sign BYTE 0
    num2Sign BYTE 0
    resultSign BYTE 0

.code

; --------------------------------------------
; ClearArray
; Clears an array by filling it with zero.
;
; Input:
;   EDI = address of array
;   ECX = number of bytes to clear
; --------------------------------------------
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

; --------------------------------------------
; StringToArray
; Converts inputBuffer into reversed digit array.
;
; Input:
;   EDI = destination array address
;   EBX = destination length variable address
;   EDX = destination sign variable address
; --------------------------------------------
StringToArray PROC USES esi edi ebx ecx edx eax
    ; Clear destination array first
    push edi
    push ebx
    push edx

    mov ecx, MAX_DIGITS
    call ClearArray

    pop edx
    pop ebx
    pop edi

    ; Default sign is positive
    mov BYTE PTR [edx], 0

    mov esi, OFFSET inputBuffer

    ; Check negative sign
    cmp BYTE PTR [esi], '-'
    jne countDigits

    mov BYTE PTR [edx], 1
    inc esi

countDigits:
    mov ecx, 0

countLoop:
    mov al, [esi + ecx]
    cmp al, 0
    je saveLength

    inc ecx
    jmp countLoop

saveLength:
    mov DWORD PTR [ebx], ecx

    ; Move ESI to the last digit
    add esi, ecx
    dec esi

convertLoop:
    cmp ecx, 0
    je convertDone

    mov al, [esi]
    sub al, '0'

    mov [edi], al

    inc edi
    dec esi
    dec ecx
    jmp convertLoop

convertDone:
    ret
StringToArray ENDP

END

