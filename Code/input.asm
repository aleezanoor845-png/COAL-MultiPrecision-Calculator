; ============================================
; Member 1: Aleeza Noor
; Module: Input
; File: input.asm
; Purpose: Read user input into inputBuffer
; ============================================

INCLUDE Irvine32.inc

PUBLIC ReadNumber

EXTERN inputBuffer:BYTE

MAX_INPUT EQU 209

.data
    prompt BYTE "Enter a large number: ", 0

.code

; --------------------------------------------
; ReadNumber
; Reads a large number from the user.
;
; Output:
;   inputBuffer contains the typed number.
; --------------------------------------------
ReadNumber PROC
    mov edx, OFFSET prompt
    call WriteString

    mov edx, OFFSET inputBuffer
    mov ecx, MAX_INPUT
    call ReadString

    ret
ReadNumber ENDP

END
