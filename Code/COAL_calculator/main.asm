INCLUDE Irvine32.inc

DisplayResult PROTO
RunAnalysis PROTO

.data

menuMsg BYTE "====== Multi-Precision Calculator ======",0dh,0ah
         BYTE "1. Show Result",0dh,0ah
         BYTE "2. Run Analysis",0dh,0ah
         BYTE "3. Exit",0dh,0ah
         BYTE "Enter choice: ",0

PUBLIC resultMsg

resultMsg BYTE "Large Number Result Displayed Successfully!",0dh,0ah,0

choice DWORD ?

.code

main PROC

menuLoop:

    mov edx, OFFSET menuMsg
    call WriteString

    call ReadInt
    mov choice, eax

    cmp choice, 1
    je displayOption

    cmp choice, 2
    je analysisOption

    cmp choice, 3
    je exitProgram

    call CrlF
    jmp menuLoop

displayOption:
    call DisplayResult
    jmp menuLoop

analysisOption:
    call RunAnalysis
    jmp menuLoop

exitProgram:
    exit

main ENDP

END main