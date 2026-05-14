; ============================================
; Member 1: Aleeza Noor
; Module: Input & Storage
; File: input.asm
; ============================================
INCLUDE Irvine32.inc

.data
    prompt      BYTE "Enter a large number: ", 0
    inputBuffer BYTE 210 DUP(0)

.code

; ----------------------------
; ReadNumber
; Reads user input into inputBuffer
; Output: inputBuffer filled, EAX = length
; ----------------------------
ReadNumber PROC
    mov  edx, OFFSET prompt
    call WriteString
    mov  edx, OFFSET inputBuffer
    mov  ecx, 210
    call ReadString
    ; EAX already = number of chars read (Irvine ReadString sets this)
    ret
ReadNumber ENDP

END