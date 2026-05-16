; Urwa Imran | analysis.asm
; Simple analysis output for the report/demo requirements.
; Shows digit counts and fixed memory usage for the arrays.

INCLUDE Irvine32.inc

PUBLIC RunAnalysis

EXTERN num1Len:DWORD
EXTERN num2Len:DWORD
EXTERN resultLen:DWORD

.data
    analysisTitle BYTE "Analysis Summary", 0
    digits1Msg BYTE "Input 1 digits: ", 0
    digits2Msg BYTE "Input 2 digits: ", 0
    resultDigitsMsg BYTE "Result digits: ", 0
    memoryMsg BYTE "Static digit storage used: num1=200 bytes, num2=200 bytes, result=400 bytes", 0
    noteMsg BYTE "Large-number arithmetic is performed digit-by-digit on reversed arrays.", 0

.code

RunAnalysis PROC USES eax edx
    call CrlF

    mov edx, OFFSET analysisTitle
    call WriteString
    call CrlF

    mov edx, OFFSET digits1Msg
    call WriteString
    mov eax, num1Len
    call WriteDec
    call CrlF

    mov edx, OFFSET digits2Msg
    call WriteString
    mov eax, num2Len
    call WriteDec
    call CrlF

    mov edx, OFFSET resultDigitsMsg
    call WriteString
    mov eax, resultLen
    call WriteDec
    call CrlF

    mov edx, OFFSET memoryMsg
    call WriteString
    call CrlF

    mov edx, OFFSET noteMsg
    call WriteString
    call CrlF

    ret
RunAnalysis ENDP
END 