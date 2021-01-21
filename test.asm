global main
extern puts
extern exit
extern scanf 
extern printf 

section .data
    nameAndTitleStr: db "Hello World",0xA,"Instructions go here",0xA,"Please enter three numbers in descending order: A>B>C",0
    closingStr:      db "Goodbye",0
    oneIntFormatStr: db "%d",0
    firstFailStr:    db "Error: A <= B, exiting",0
    secondFailStr:   db "Error: B <= C, exiting",0
    calcPrintStr1:   db "%d+%d=%d",0xA,0
    calcPrintStr2:   db "%d-%d=%d",0xA,0
    calcPrintStr3:   db "%d+%d+%d=%d",0xA,0

section .text

main:
    push rbp
    mov  rbp, rsp 
    
    mov  rdi, nameAndTitleStr
    call puts

    mov rdi, oneIntFormatStr
    mov rsi, rsp
    call scanf 
    mov r12, [rsp]

    mov rdi, oneIntFormatStr
    mov rsi, rsp
    call scanf 
    mov r13, [rsp]

    cmp r12, r13
    jle FirstCompareFail     

    mov rdi, oneIntFormatStr
    mov rsi, rsp
    call scanf 
    mov r14, [rsp]

    cmp r13, r14
    jle SecondCompareFail
    jmp PerformCalculations 

FirstCompareFail: 
    mov  rdi, firstFailStr  
    call puts
    jmp  Ending 
SecondCompareFail: 
    mov  rdi, secondFailStr  
    call puts
    jmp  Ending 


PerformCalculations:
    xor r15, r15
    add r15, r12
    add r15, r13

    mov rdi, calcPrintStr1
    mov rsi, r12
    mov rdx, r13
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r12
    sub r15, r13
    mov rdi, calcPrintStr2
    mov rsi, r12
    mov rdx, r13
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r12
    add r15, r14
    mov rdi, calcPrintStr1 
    mov rsi, r12
    mov rdx, r14
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r12
    sub r15, r14
    mov rdi, calcPrintStr2
    mov rsi, r12
    mov rdx, r14
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r13
    add r15, r14
    mov rdi, calcPrintStr1 
    mov rsi, r13
    mov rdx, r14
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r13
    sub r15, r14
    mov rdi, calcPrintStr2
    mov rsi, r13
    mov rdx, r14
    mov rcx, r15
    call printf 

    xor r15, r15
    add r15, r12
    add r15, r13
    add r15, r14
    mov rdi, calcPrintStr3
    mov rsi, r12
    mov rdx, r13
    mov rcx, r14
    mov r8, r15
    call printf 

Closing:
    mov  rdi, closingStr   
    call puts

Ending:
    mov rsp, rbp
    pop	rbp		
    mov rdi, 0 		
    call exit

