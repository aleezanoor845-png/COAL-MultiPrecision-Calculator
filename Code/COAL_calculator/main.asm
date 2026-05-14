INCLUDE Irvine32.inc

DisplayResult PROTO
RunAnalysis PROTO

.data

titleMsg BYTE 0dh,0ah
          BYTE "======================================",0dh,0ah
          BYTE "     MULTI-PRECISION CALCULATOR",0dh,0ah
          BYTE "======================================",0dh,0ah,0

menuMsg BYTE 0dh,0ah
         BYTE "1. Addition",0dh,0ah
         BYTE "2. Subtraction",0dh,0ah
         BYTE "3. Multiplication",0dh,0ah
         BYTE "4. Run Analysis",0dh,0ah
         BYTE "5. Exit",0dh,0ah
         BYTE "--------------------------------------",0dh,0ah
         BYTE "Enter choice: ",0

invalidMsg BYTE 0dh,0ah
           BYTE "Invalid choice! Try again.",0dh,0ah,0

choice DWORD ?

.code

main PROC

menuLoop:

    call Clrscr

    mov edx, OFFSET titleMsg
    call WriteString

    mov edx, OFFSET menuMsg
    call WriteString

    call ReadInt
    mov choice, eax

    cmp choice, 1
    je operationOption

    cmp choice, 2
    je operationOption

    cmp choice, 3
    je operationOption

    cmp choice, 4
    je analysisOption

    cmp choice, 5
    je exitProgram

    mov edx, OFFSET invalidMsg
    call WriteString
    call WaitMsg

    jmp menuLoop

operationOption:

    call DisplayResult
    call WaitMsg
    jmp menuLoop

analysisOption:

    call RunAnalysis
    call WaitMsg
    jmp menuLoop

exitProgram:
    exit

main ENDP

END main