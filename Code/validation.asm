; ============================================
; Member 1: Aleeza Noor
; Module: Validation
; File: validation.asm
; Purpose: Validate user input
; ============================================

INCLUDE Irvine32.inc

PUBLIC ValidateNumber

EXTERN inputBuffer:BYTE

MAX_DIGITS EQU 200

.data
    invalidMsg BYTE "Invalid input! Try again.", 0

.code

; --------------------------------------------
; ValidateNumber
; Validates inputBuffer.
;
; Output:
;   EAX = 1 if valid
;   EAX = 0 if invalid
; --------------------------------------------
ValidateNumber PROC USES esi ecx
    mov esi, OFFSET inputBuffer
    mov ecx, 0

    ; Empty input is invalid
    cmp BYTE PTR [esi], 0
    je invalidInput

    ; Optional minus sign only at start
    cmp BYTE PTR [esi], '-'
    jne checkDigits

    inc esi

    ; Minus sign alone is invalid
    cmp BYTE PTR [esi], 0
    je invalidInput

checkDigits:
    mov al, [esi]

    cmp al, 0
    je validInput

    cmp al, '0'
    jl invalidInput

    cmp al, '9'
    jg invalidInput

    inc ecx

    cmp ecx, MAX_DIGITS
    jg invalidInput

    inc esi
    jmp checkDigits

validInput:
    cmp ecx, 0
    je invalidInput

    mov eax, 1
    ret

invalidInput:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrlF

    mov eax, 0
    ret
ValidateNumber ENDP

END
