INCLUDE Irvine32.inc

.data

analysisMsg BYTE "Running Analysis...",0dh,0ah,0

.code

RunAnalysis PROC

    mov edx, OFFSET analysisMsg
    call WriteString

    ret

RunAnalysis ENDP

END