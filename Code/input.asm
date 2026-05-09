; ============================================
; Member 1: Aleeza Noor
; Module: Input & Storage
; File: input.asm
; ============================================

INCLUDE Irvine32.inc

.data
    prompt      BYTE "Enter a large number: ", 0
    inputBuffer BYTE 210 DUP(0)
    invalidMsg  BYTE "Invalid input! Try again.", 0
    
.code

; ============================================
; ReadNumber PROC
; Purpose: Reads number as string from user
; Input: nothing
; Output: inputBuffer filled with user input
; ============================================
ReadNumber PROC
    mov  edx, OFFSET prompt
    call WriteString
    
    mov  edx, OFFSET inputBuffer
    mov  ecx, 210
    call ReadString
    
    ret
ReadNumber ENDP

main PROC
    call ReadNumber
    exit
main ENDP

END main