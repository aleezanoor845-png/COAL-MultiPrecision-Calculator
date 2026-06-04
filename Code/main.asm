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
RunExpressionMode PROTO

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
    option4 BYTE "4. Expression Mode - choose this before typing full expression", 0
    option5 BYTE "5. Exit", 0
    choiceMsg BYTE "Enter choice: ", 0
    firstMsg BYTE "First number", 0
    secondMsg BYTE "Second number", 0
    invalidChoiceMsg BYTE "Invalid choice!", 0
    invalidInputMsg BYTE "Please enter the numbers again.", 0
    lineMsg BYTE "----------------------------------------", 0
    choiceBuffer BYTE 20 DUP(0)
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

    mov edx, OFFSET option5
    call WriteString
    call CrlF

    mov edx, OFFSET choiceMsg
    call WriteString
    ret
ShowMenu ENDP

; ReadMenuChoice reads the full choice line.
; This avoids Irvine's "<invalid integer>" message if a user types text.
; Output:
;   EAX = 1 to 5 for a valid choice
;   EAX = 0 for invalid input
ReadMenuChoice PROC USES edx ecx
    mov edx, OFFSET choiceBuffer
    mov ecx, SIZEOF choiceBuffer
    call ReadString

    cmp eax, 1
    jne badChoice

    mov al, choiceBuffer[0]
    cmp al, '1'
    jl badChoice
    cmp al, '5'
    jg badChoice

    sub al, '0'
    movzx eax, al
    ret

badChoice:
    xor eax, eax
    ret
ReadMenuChoice ENDP

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
    call ReadMenuChoice
    mov choice, eax

    cmp choice, 5
    je exitProgram

    cmp choice, 1
    jl invalidChoice

    cmp choice, 4
    jg invalidChoice

    cmp choice, 4
    je doExpression

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

doExpression:
    call RunExpressionMode
    cmp eax, 1
    jne mainLoop
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

