        .text
        .align  2
        .global m1p1
        .type   m1p1, %function
m1p1:
        @ - edge case - first letter. does not have a symbol preceeding it
        @ - we have to remember what is the previous symbol
        @ - iterate once through a string

        @ r0 - pointer at the buffer 
        @ r1 - string iterator
        @ r2 - the letter at address r1
        @ r3 - flag if symbol should be capitalized (prev. symbol is space)

        STMFD   sp!, {r0-r10}

        MOV     r1, r0  @ setting r1 to point at the beginning of r0
        SUB     r1, r1, #1
        MOV     r3, #1  @ first symbol of the buffer should be capitalized

loop:
        LDRB    r2, [r1,#1]!    @ reading the symbol at the position and post-incrementing the iterator r1

        CMP     r2, #0          @ if we have reached the NUL symbol, we should exit
        BEQ     exit

        CMP     r2, #32         @ checking if the symbol read is a space
        BEQ     is_space

        CMP     r3, #1          @ checking if a symbol should be capitalized (if it is a letter)
        BEQ     capitalize

        @ checking if a symbol should be lowercase (if it is a letter)
        @ let's check if it is a capitalized letter
        CMP     r2, #65
        BLT     loop
        CMP     r2, #90
        BGT     loop

        ADD     r2, r2, #32
        STRB    r2, [r1]
        B       loop

is_space:
        MOV     r3, #1
        B loop

capitalize:
        MOV     r3, #0          @ setting the space flag back to false

        @ let's check if it is a lowercase letter
        CMP     r2, #97
        BLT     loop
        CMP     r2, #122
        BGT     loop

        SUB     r2, r2, #32     @ making the letter capitalized
        STRB    r2, [r1]        @ writing the letter down
        B       loop

exit:
        LDMFD   sp!, {r0-r10}
        BX      lr
