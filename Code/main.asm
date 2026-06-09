; Urwa Imran | main.asm
; Final menu and integration controller.
; This is the only final file that should contain main PROC.

INCLUDE Irvine32.inc

ReadNumber PROTO
ValidateNumber PROTO
StringToArray PROTO

AddLarge PROTO
SubtractLarge PROTO
MultiplyLarge PROTO

DisplayResult PROTO
RunAnalysis PROTO

EXTERN num1:BYTE
EXTERN num2:BYTE
EXTERN num1Len:DWORD
EXTERN num2Len:DWORD
EXTERN num1Sign:BYTE
EXTERN num2Sign:BYTE

.data
    menuTitle BYTE "Multi-Precision Arithmetic Calculator", 0
    option1 BYTE "1. Addition", 0
    option2 BYTE "2. Subtraction", 0
    option3 BYTE "3. Multiplication", 0
    option4 BYTE "4. Exit", 0
    choiceMsg BYTE "Enter choice: ", 0
    firstMsg BYTE "First number", 0
    secondMsg BYTE "Second number", 0
    invalidChoiceMsg BYTE "Invalid choice!", 0
    invalidInputMsg BYTE "Please enter the numbers again.", 0
    lineMsg BYTE "----------------------------------------", 0
    choice DWORD 0

.code

; ShowMenu displays the calculator choices.
ShowMenu PROC
    call CrlF
    mov edx, OFFSET lineMsg
    call WriteString
    call CrlF

    mov edx, OFFSET menuTitle
    call WriteString
    call CrlF

    mov edx, OFFSET option1
    call WriteString
    call CrlF

    mov edx, OFFSET option2
    call WriteString
    call CrlF

    mov edx, OFFSET option3
    call WriteString
    call CrlF

    mov edx, OFFSET option4
    call WriteString
    call CrlF

    mov edx, OFFSET choiceMsg
    call WriteString
    ret
ShowMenu ENDP

; ReadFirstNumber calls Member 1's input, validation, and storage flow.
ReadFirstNumber PROC
    call CrlF
    mov edx, OFFSET firstMsg
    call WriteString
    call CrlF

    call ReadNumber
    call ValidateNumber
    cmp eax, 1
    jne readFirstInvalid

    mov edi, OFFSET num1
    mov ebx, OFFSET num1Len
    mov edx, OFFSET num1Sign
    call StringToArray

    mov eax, 1
    ret

readFirstInvalid:
    mov eax, 0
    ret
ReadFirstNumber ENDP

; ReadSecondNumber repeats the same flow for num2.
ReadSecondNumber PROC
    call CrlF
    mov edx, OFFSET secondMsg
    call WriteString
    call CrlF

    call ReadNumber
    call ValidateNumber
    cmp eax, 1
    jne readSecondInvalid

    mov edi, OFFSET num2
    mov ebx, OFFSET num2Len
    mov edx, OFFSET num2Sign
    call StringToArray

    mov eax, 1
    ret

readSecondInvalid:
    mov eax, 0
    ret
ReadSecondNumber ENDP

main PROC
mainLoop:
    call ShowMenu
    call ReadInt
    mov choice, eax

    cmp choice, 4
    je exitProgram

    cmp choice, 1
    jl invalidChoice

    cmp choice, 3
    jg invalidChoice

    call ReadFirstNumber
    cmp eax, 1
    jne inputFailed

    call ReadSecondNumber
    cmp eax, 1
    jne inputFailed

    cmp choice, 1
    je doAddition

    cmp choice, 2
    je doSubtraction

    cmp choice, 3
    je doMultiplication

doAddition:
    call AddLarge
    jmp showAnswer

doSubtraction:
    call SubtractLarge
    jmp showAnswer

doMultiplication:
    call MultiplyLarge
    jmp showAnswer

showAnswer:
    call DisplayResult
    call RunAnalysis
    jmp mainLoop

invalidChoice:
    mov edx, OFFSET invalidChoiceMsg
    call WriteString
    call CrlF
    jmp mainLoop

inputFailed:
    mov edx, OFFSET invalidInputMsg
    call WriteString
    call CrlF
    jmp mainLoop

exitProgram:
    exit
main ENDP

END main

