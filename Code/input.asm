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

; ----------------------------
; ReadNumber
; reads input from user
; ----------------------------
ReadNumber PROC
    mov  edx, OFFSET prompt
    call WriteString
    mov  edx, OFFSET inputBuffer
    mov  ecx, 210
    call ReadString
    ret
ReadNumber ENDP

; ----------------------------
; ValidateNumber
; checks each character
; returns 1 if valid, 0 if not
; ----------------------------
ValidateNumber PROC
    mov  esi, OFFSET inputBuffer

    ; if empty, invalid
    cmp  BYTE PTR [esi], 0
    je   invalid

    ; allow minus sign at start
    cmp  BYTE PTR [esi], '-'
    jne  checkDigits
    inc  esi

checkDigits:
    mov  al, [esi]
    cmp  al, 0        ; end of string
    je   valid
    cmp  al, '0'      ; less than 0
    jl   invalid
    cmp  al, '9'      ; greater than 9
    jg   invalid
    inc  esi
    jmp  checkDigits

invalid:
    mov  edx, OFFSET invalidMsg
    call WriteString
    call CrlF
    mov  eax, 0
    ret

valid:
    mov  eax, 1
    ret
ValidateNumber ENDP

main PROC
    call ReadNumber
    call ValidateNumber
    cmp  eax, 1
    je   inputOk
    jmp  done
inputOk:
    mov  edx, OFFSET inputBuffer
    call WriteString
    call CrlF
done:
    exit
main ENDP

END main