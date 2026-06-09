; ------------------------------------------------------------
; Expression Module
; Adds bracket expressions, operator precedence, power, factorial,
; and number systems for the calculator.
; Correct prefixes:
;   Binary      0b1010
;   Octal       0o7
;   Hexadecimal 0xA
; Do not write prefixes with slash, such as 0/b or 0/a.
; Examples: (248+2)*34, [2^5+3!], {0b1010+0o7}, 10%3
; ------------------------------------------------------------

INCLUDE Irvine32.inc

PUBLIC RunExpressionMode

DisplayResult PROTO
ClearArray PROTO

EXTERN result:BYTE
EXTERN resultLen:DWORD
EXTERN resultSign:BYTE

MAX_EXPR EQU 120
MAX_RESULT_DIGITS EQU 400

.data
    exprPrompt BYTE "Enter expression: ", 0
    exprHelp BYTE "Use + - * / % ^ ! brackets () [] {}, and prefixes 0b 0o 0x", 0
    exprBaseHelp BYTE "Examples: 0b1010, 0o7, 0xA. Do not use 0/b, 0/o, or 0/a.", 0
    exprInvalidMsg BYTE "Invalid expression! Check operators and brackets.", 0
    exprBaseMsg BYTE "Invalid number system! Use 0b1010, 0o7, or 0xA. Do not write 0/b or 0/a.", 0
    exprCharMsg BYTE "Invalid character! Only digits, A-F for hex, operators, and brackets are allowed.", 0
    exprDivZeroMsg BYTE "Division by zero is not allowed!", 0
    exprFactMsg BYTE "Factorial only works for zero or positive values!", 0

    exprBuffer BYTE MAX_EXPR DUP(0)
    exprPos DWORD 0
    exprError BYTE 0
    baseError BYTE 0
    charError BYTE 0
    divZeroError BYTE 0
    factError BYTE 0

.code

; ------------------------------------------------------------
; SkipSpaces
; Moves exprPos forward while spaces are found.
; ------------------------------------------------------------
SkipSpaces PROC USES esi eax
    mov esi, exprPos

spaceLoop:
    mov al, BYTE PTR [esi]
    cmp al, ' '
    jne spaceDone
    inc esi
    jmp spaceLoop

spaceDone:
    mov exprPos, esi
    ret
SkipSpaces ENDP

; ------------------------------------------------------------
; PeekChar
; Returns the next non-space character in AL without consuming it.
; ------------------------------------------------------------
PeekChar PROC USES esi
    call SkipSpaces
    mov esi, exprPos
    mov al, BYTE PTR [esi]
    ret
PeekChar ENDP

; ------------------------------------------------------------
; GetChar
; Returns the next non-space character in AL and consumes it.
; ------------------------------------------------------------
GetChar PROC USES esi
    call SkipSpaces
    mov esi, exprPos
    mov al, BYTE PTR [esi]
    cmp al, 0
    je getDone
    inc esi
    mov exprPos, esi

getDone:
    ret
GetChar ENDP

ParseExpression PROTO
ParseTerm PROTO
ParsePower PROTO
ParseFactor PROTO
ParsePrimary PROTO

; ------------------------------------------------------------
; MarkBaseError
; Gives a clear message for wrong base prefixes or digits.
; ------------------------------------------------------------
MarkBaseError PROC
    mov exprError, 1
    mov baseError, 1
    ret
MarkBaseError ENDP

; ------------------------------------------------------------
; MarkCharError
; Gives a clear message for unsupported characters.
; ------------------------------------------------------------
MarkCharError PROC
    mov exprError, 1
    mov charError, 1
    ret
MarkCharError ENDP

; ------------------------------------------------------------
; ParseExpression: handles + and -
; ------------------------------------------------------------
ParseExpression PROC USES ebx edx
    call ParseTerm
    mov ebx, eax

exprLoop:
    cmp exprError, 1
    je exprDone

    call PeekChar
    cmp al, '+'
    je exprAdd
    cmp al, '-'
    je exprSub
    jmp exprDone

exprAdd:
    call GetChar
    push ebx
    call ParseTerm
    pop ebx
    add ebx, eax
    jmp exprLoop

exprSub:
    call GetChar
    push ebx
    call ParseTerm
    pop ebx
    sub ebx, eax
    jmp exprLoop

exprDone:
    mov eax, ebx
    ret
ParseExpression ENDP

; ------------------------------------------------------------
; ParseTerm: handles *, /, and %
; ------------------------------------------------------------
ParseTerm PROC USES ebx ecx edx
    call ParsePower
    mov ebx, eax

termLoop:
    cmp exprError, 1
    je termDone

    call PeekChar
    cmp al, '*'
    je termMul
    cmp al, '/'
    je termDiv
    cmp al, '%'
    je termMod
    jmp termDone

termMul:
    call GetChar
    push ebx
    call ParsePower
    pop ebx
    imul ebx, eax
    jmp termLoop

termDiv:
    call GetChar
    push ebx
    call ParsePower
    mov ecx, eax
    pop ebx

    cmp ecx, 0
    jne doDivide
    mov exprError, 1
    mov divZeroError, 1
    jmp termDone

doDivide:
    mov eax, ebx
    cdq
    idiv ecx
    mov ebx, eax
    jmp termLoop

termMod:
    call GetChar
    push ebx
    call ParsePower
    mov ecx, eax
    pop ebx

    cmp ecx, 0
    jne doModulo
    mov exprError, 1
    mov divZeroError, 1
    jmp termDone

doModulo:
    mov eax, ebx
    cdq
    idiv ecx
    mov ebx, edx
    jmp termLoop

termDone:
    mov eax, ebx
    ret
ParseTerm ENDP

; ------------------------------------------------------------
; ParsePower: handles ^ as right-associative power.
; ------------------------------------------------------------
ParsePower PROC USES ebx ecx edx
    call ParseFactor
    mov ebx, eax

    call PeekChar
    cmp al, '^'
    jne powerDone

    call GetChar
    call ParsePower
    mov ecx, eax

    cmp ecx, 0
    jge powerStart
    mov exprError, 1
    jmp powerDone

powerStart:
    mov eax, 1

powerLoop:
    cmp ecx, 0
    je powerSave
    imul eax, ebx
    dec ecx
    jmp powerLoop

powerSave:
    mov ebx, eax

powerDone:
    mov eax, ebx
    ret
ParsePower ENDP

; ------------------------------------------------------------
; ParseFactor: handles factorial after a value.
; ------------------------------------------------------------
ParseFactor PROC USES ebx ecx
    call ParsePrimary
    mov ebx, eax

factCheck:
    cmp exprError, 1
    je factDone

    call PeekChar
    cmp al, '!'
    jne factDone

    call GetChar
    cmp ebx, 0
    jge factStart
    mov exprError, 1
    mov factError, 1
    jmp factDone

factStart:
    mov ecx, ebx
    mov eax, 1

factLoop:
    cmp ecx, 1
    jle factSave
    imul eax, ecx
    dec ecx
    jmp factLoop

factSave:
    mov ebx, eax
    jmp factCheck

factDone:
    mov eax, ebx
    ret
ParseFactor ENDP

; ------------------------------------------------------------
; ParseNumber: handles decimal, binary, octal, and hexadecimal.
; Prefix rules:
;   Decimal     25
;   Binary      0b1010
;   Octal       0o17
;   Hexadecimal 0x1F
; ------------------------------------------------------------
ParseNumber PROC USES ebx ecx edx esi
    mov edx, 10
    xor ebx, ebx
    xor esi, esi

    call GetChar
    cmp al, '0'
    jne firstDecimalDigit

    call PeekChar
    cmp al, 'b'
    je binaryPrefix
    cmp al, 'B'
    je binaryPrefix
    cmp al, 'o'
    je octalPrefix
    cmp al, 'O'
    je octalPrefix
    cmp al, 'x'
    je hexPrefix
    cmp al, 'X'
    je hexPrefix
    cmp al, 'A'
    jl leadingZeroIsDecimal
    cmp al, 'Z'
    jle badBaseNumber
    cmp al, 'a'
    jl leadingZeroIsDecimal
    cmp al, 'z'
    jle badBaseNumber

leadingZeroIsDecimal:
    mov ebx, 0
    mov esi, 1
    jmp digitLoopStart

firstDecimalDigit:
    sub al, '0'
    movzx ebx, al
    mov esi, 1
    jmp digitLoopStart

binaryPrefix:
    call GetChar
    mov edx, 2
    xor esi, esi
    jmp digitLoopStart

octalPrefix:
    call GetChar
    mov edx, 8
    xor esi, esi
    jmp digitLoopStart

hexPrefix:
    call GetChar
    mov edx, 16
    xor esi, esi

digitLoopStart:
    call PeekChar

    cmp al, '0'
    jl checkUpperHex
    cmp al, '9'
    jg checkUpperHex
    sub al, '0'
    jmp digitReady

checkUpperHex:
    cmp al, 'A'
    jl numberDone
    cmp al, 'F'
    jg checkUpperBad
    sub al, 'A'
    add al, 10
    jmp digitReady

checkUpperBad:
    cmp al, 'Z'
    jle badBaseNumber

checkLowerHex:
    cmp al, 'a'
    jl numberDone
    cmp al, 'f'
    jg checkLowerBad
    sub al, 'a'
    add al, 10
    jmp digitReady

checkLowerBad:
    cmp al, 'z'
    jle badBaseNumber
    jmp numberDone

digitReady:
    movzx eax, al
    cmp eax, edx
    jl digitAccepted

    call MarkBaseError
    jmp numberExit

digitAccepted:
    push eax
    call GetChar
    mov eax, ebx
    imul eax, edx
    pop ecx
    add eax, ecx
    mov ebx, eax
    inc esi
    jmp digitLoopStart

numberDone:
    cmp esi, 0
    jne numberExit
    call MarkBaseError
    jmp numberExit

badBaseNumber:
    call MarkBaseError

numberExit:
    mov eax, ebx
    ret
ParseNumber ENDP

; ------------------------------------------------------------
; ParsePrimary: handles numbers, bracket types, and unary signs.
; ------------------------------------------------------------
ParsePrimary PROC USES ebx ecx edx
    call PeekChar

    cmp al, '('
    je primaryRoundBracket

    cmp al, '['
    je primarySquareBracket

    cmp al, '{'
    je primaryCurlyBracket

    cmp al, '-'
    je primaryNegative

    cmp al, '+'
    je primaryPositive

    cmp al, '0'
    jl primaryBad
    cmp al, '9'
    jg primaryBad

    call ParseNumber
    ret

primaryRoundBracket:
    mov ecx, ')'
    jmp primaryBracket

primarySquareBracket:
    mov ecx, ']'
    jmp primaryBracket

primaryCurlyBracket:
    mov ecx, '}'

primaryBracket:
    call GetChar
    push ecx
    call ParseExpression
    mov ebx, eax

    pop ecx
    call GetChar
    cmp al, cl
    je bracketOk

    mov exprError, 1

bracketOk:
    mov eax, ebx
    ret

primaryNegative:
    call GetChar
    call ParsePrimary
    neg eax
    ret

primaryPositive:
    call GetChar
    call ParsePrimary
    ret

primaryBad:
    cmp al, 'A'
    jl badCharacter
    cmp al, 'Z'
    jle badBaseCharacter
    cmp al, 'a'
    jl badCharacter
    cmp al, 'z'
    jle badBaseCharacter

badCharacter:
    call MarkCharError
    xor eax, eax
    ret

badBaseCharacter:
    call MarkBaseError
    xor eax, eax
    ret
ParsePrimary ENDP

; ------------------------------------------------------------
; SaveSignedResult
; Converts signed EAX into the shared reversed digit result array.
; ------------------------------------------------------------
SaveSignedResult PROC USES ebx ecx edx edi esi
    mov ebx, eax

    mov edi, OFFSET result
    mov ecx, MAX_RESULT_DIGITS
    call ClearArray

    mov resultSign, 0

    cmp ebx, 0
    jge absReady

    mov resultSign, 1
    neg ebx

absReady:
    cmp ebx, 0
    jne convertLoopStart

    mov BYTE PTR result[0], 0
    mov resultLen, 1
    mov resultSign, 0
    ret

convertLoopStart:
    xor esi, esi

convertLoop:
    cmp ebx, 0
    je convertDone

    mov eax, ebx
    xor edx, edx
    mov ecx, 10
    div ecx

    mov BYTE PTR result[esi], dl
    mov ebx, eax
    inc esi
    jmp convertLoop

convertDone:
    mov resultLen, esi
    ret
SaveSignedResult ENDP

; ------------------------------------------------------------
; RunExpressionMode
; Reads and evaluates one full expression.
; Output:
;   EAX = 1 if result is ready
;   EAX = 0 if expression was invalid
; ------------------------------------------------------------
RunExpressionMode PROC USES edx ecx
    call CrlF
    mov edx, OFFSET exprHelp
    call WriteString
    call CrlF
    mov edx, OFFSET exprBaseHelp
    call WriteString
    call CrlF

    mov edx, OFFSET exprPrompt
    call WriteString

    mov edx, OFFSET exprBuffer
    mov ecx, MAX_EXPR
    call ReadString

    mov exprPos, OFFSET exprBuffer
    mov exprError, 0
    mov baseError, 0
    mov charError, 0
    mov divZeroError, 0
    mov factError, 0

    cmp eax, 0
    jne expressionHasInput

    mov exprError, 1
    xor eax, eax
    jmp expressionChecked

expressionHasInput:

    call ParseExpression
    push eax

    call PeekChar
    cmp al, 0
    je expressionEndOk
    mov exprError, 1

expressionEndOk:
    pop eax

expressionChecked:
    cmp exprError, 1
    jne expressionValid

    cmp baseError, 1
    je showBaseError

    cmp charError, 1
    je showCharError

    cmp divZeroError, 1
    je showDivZero

    cmp factError, 1
    je showFactError

    mov edx, OFFSET exprInvalidMsg
    call WriteString
    call CrlF
    xor eax, eax
    ret

showBaseError:
    mov edx, OFFSET exprBaseMsg
    call WriteString
    call CrlF
    xor eax, eax
    ret

showCharError:
    mov edx, OFFSET exprCharMsg
    call WriteString
    call CrlF
    xor eax, eax
    ret

showDivZero:
    mov edx, OFFSET exprDivZeroMsg
    call WriteString
    call CrlF
    xor eax, eax
    ret

showFactError:
    mov edx, OFFSET exprFactMsg
    call WriteString
    call CrlF
    xor eax, eax
    ret

expressionValid:
    call SaveSignedResult
    mov eax, 1
    ret
RunExpressionMode ENDP

END
