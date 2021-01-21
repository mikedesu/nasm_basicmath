; --------------------
; this is a vim hack to change the syntax highlighting
; --------------------
;asmsyntax=nasm
; --------------------

global main
extern puts
extern exit
extern scanf 
extern printf 

; any sort of pre-defined values that we need can go here
; this would include format strings, constants, etc
section .data
    nameAndTitleStr: db "Hello World",0
    instructionStr:  db "instructions go here",0
    userPromptStr:   db "Please enter three numbers in descending order: A > B > C",0
    closingStr:      db "Goodbye",0
    oneIntFormatStr: db "%d",0
    firstFailStr:    db "Error: A <= B, exiting",0
    secondFailStr:   db "Error: B <= C, exiting",0

    calcPrintStr1:   db "%d+%d=%d",0xA,0
    calcPrintStr2:   db "%d-%d=%d",0xA,0
    calcPrintStr3:   db "%d+%d+%d=%d",0xA,0

section .text

main:
    ; push the base pointer to the stack
    ; this is needed whenever you plan on calling a function or jumping to
    ; another part of the stack
    push rbp
    ; update the base pointer to the value held by the stack pointer
    ; this effectively adjusts our "position" in the stack
    mov  rbp, rsp 
    
    ; we are copying the location of our string into rdi
    ; this is how parameters get set up when calling a function
    ; here, we are preparing to call 'puts', or put string, so we can print 
    mov  rdi, nameAndTitleStr
    call puts
    mov  rdi, instructionStr
    call puts
    mov  rdi, userPromptStr  
    call puts

    ; read one number into a register
    ; first we load the format string
    mov rdi, oneIntFormatStr
    ; next, we set a destination address for the scanf to store our integer in
    ; here, we are just going to use the current address that rsp points to
    mov rsi, rsp
    call scanf 
     
     ; to verify that I've read in one integer, I am going to print it back out
        ; first we load the format string
        ; next, instead of loading the address stored in rsp, we get the *value* at 
        ; that address and store it in rsi
        ;mov rdi, oneIntFormatStr
        ;mov rsi, [rsp]
        ;call printf

    ; we need to copy this value into a temporary register
    ; actually, we need 3 temporary registers
    ; this will make comparing our 3 values as well as computing results easy
    ;
    ; r12, r13, r14 should be sufficient for us
    mov r12, [rsp]

    ; Second number
    mov rdi, oneIntFormatStr
    mov rsi, rsp
    call scanf 

        ; to verify that I've read in one integer, I am going to print it back out
        ; first we load the format string
        ; next, instead of loading the address stored in rsp, we get the *value* at 
        ; that address and store it in rsi
        ;mov rdi, oneIntFormatStr
        ;mov rsi, [rsp]
        ;call printf

    ; Copy second number into r13
    mov r13, [rsp]

    ; At this point, we're being asked to verify that rbx is less than rax
    ; so we need to compare the values stored in these two registers
    cmp r12, r13
    jle FirstCompareFail     

    ; Third number
    mov rdi, oneIntFormatStr
    mov rsi, rsp
    call scanf 

    ; Copy third number into r14
    mov r14, [rsp]

    ; Verify that C < B < A
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

; A+B=
; there's a reason for why we do the following to achieve this
; let's start by clearing out r15
    xor r15, r15
; now that r15 is 0, we can add r12 to it
    add r15, r12
; lets add r13 now
    add r15, r13
; load our format string into param 1
    mov rdi, calcPrintStr1
; copy r12 into param 2
    mov rsi, r12
; copy r13 into param 3
    mov rdx, r13
; copy r15 into param 4
    mov rcx, r15
; perform the printf
    call printf 

; the following operate the same way

; A-B=
    xor r15, r15
    add r15, r12
    sub r15, r13
    mov rdi, calcPrintStr2
    mov rsi, r12
    mov rdx, r13
    mov rcx, r15
    call printf 

; A+C=
    xor r15, r15
    add r15, r12
    add r15, r14
    mov rdi, calcPrintStr1 
    mov rsi, r12
    mov rdx, r14
    mov rcx, r15
    call printf 

; A-C=
    xor r15, r15
    add r15, r12
    sub r15, r14
    mov rdi, calcPrintStr2
    mov rsi, r12
    mov rdx, r14
    mov rcx, r15
    call printf 

; B+C=
    xor r15, r15
    add r15, r13
    add r15, r14
    mov rdi, calcPrintStr1 
    mov rsi, r13
    mov rdx, r14
    mov rcx, r15
    call printf 

; B-C=
    xor r15, r15
    add r15, r13
    sub r15, r14
    mov rdi, calcPrintStr2
    mov rsi, r13
    mov rdx, r14
    mov rcx, r15
    call printf 

; A+B+C=
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


; now that we are ready to close the program, 
; we will print out our closing message
Closing:
    mov  rdi, closingStr   
    call puts

; to finish most programs, we copy the base pointer
; back into the stack pointer, pop the base pointer,
; load up our success exit code into param 1, then call exit
Ending:
    mov rsp, rbp
    pop	rbp		
    mov rdi, 0 		
    call exit

