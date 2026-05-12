INCLUDE Irvine32.inc

.data

menuMsg BYTE "====== Multi-Precision Calculator ======",0dh,0ah
         BYTE "1. Addition",0dh,0ah
         BYTE "2. Subtraction",0dh,0ah
         BYTE "3. Multiplication",0dh,0ah
         BYTE "4. Exit",0dh,0ah
         BYTE "Enter choice: ",0

addMsg BYTE "Addition selected",0dh,0ah,0
subMsg BYTE "Subtraction selected",0dh,0ah,0
mulMsg BYTE "Multiplication selected",0dh,0ah,0

choice DWORD ?

.code

main PROC

menuLoop:

    mov edx, OFFSET menuMsg
    call WriteString

    call ReadInt
    mov choice, eax

    cmp choice, 1
    je addOption

    cmp choice, 2
    je subOption

    cmp choice, 3
    je mulOption

    cmp choice, 4
    je exitProgram

    call CrlF
    jmp menuLoop

addOption:
    mov edx, OFFSET addMsg
    call WriteString
    jmp menuLoop

subOption:
    mov edx, OFFSET subMsg
    call WriteString
    jmp menuLoop

mulOption:
    mov edx, OFFSET mulMsg
    call WriteString
    jmp menuLoop

exitProgram:
    exit

main ENDP

END main