        .text
        .align  2
        .global m1p2
        .type   m1p2, %function
m1p2:
        MOV     r10, lr         @ LR will be overwritten by printf
        STMFD   sp!, {r0-r10}

        @ r0 - N 
        @ r1 - iterator from 1 to N incl.
        @ r2 - the number we check is special

        MOV     r1, #0

loop:
        ADD     r1, r1, #1
        CMP     r1, r0
        BGT     exit

        @ let's check if special 
        MOV     r2, r1

        @ r3 - sum of 1s
        MOV     r3, #0
        @ r5 - number_loop iterator
        MOV     r5, #0
        @ r6 - the mask
        MOV     r6, #1
number_loop:
        ADD     r5, r5, #1
        AND     r4, r2, r6      @ checking if the r5'th bit is a 1
        LSL     r4, r4, #1      @ normalizing r4: 0100 => 0001
        LSR     r4, r4, r5
        ADD     r3, r3, r4      @ summing up all the 1s read
        LSL     r6, r6, #1      @ moving the mask to the next left bit
        CMP     r5, #32         @ because int is 4 bytes (32 bits) long
        BLT number_loop

        @ if r3 value is 3, meaning that the num of 1s in r2 is 3, then the num is special
        CMP     r3, #3
        BEQ     is_special

        B       loop

is_special:
        STMFD   sp!, {r0-r1}

        LDR     r0, f_a         @ the printf() format
        MOV     r1, r2          @ what we print out
        BL      printf

        LDMFD   sp!, {r0-r1}
        B       loop
        
exit:   
        LDMFD   sp!, {r0-r10}
        BX      r10     @ r10 contains original lr value

f_a:    .word  format

        .data
format: .asciz "%x\n"
