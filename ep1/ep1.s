    .text
    .align  2
    .global ep1
    .type   ep1, %function
ep1:
    STMFD   sp!, {r1-r10}    @ let's save everything in stack

    @ r0 - is the pointer at the beggining of the c-string 
    @ r1 - is the checksum
    @ r2 - is the byte read from r0
    @ r3 - is a flag for odd bytes

    MOV     r1, #0  @ initial checksum value
    MOV     r3, #1  @ first byte is odd
    SUB     r0, r0, #1  @ we will add that 1 later

loop:
    LDRB    r2, [r0,#1]!

    @ check if it is a 0 byte
    CMP     r2, #0
    BEQ     exit

    @ r4 is the mask 
    @ r5 is the counter
    MOV     r4, #1
    MOV     r5, #0
count:
    AND     r6, r2, r4
    LSR     r6, r6, r5
    CMP     r6, r3
    ADDEQ   r1, r1, #1
    ADD     r5, r5, #1
    LSL     r4, r4, #1
    CMP     r5, #8
    BLT     count

    @ if r3 = 1, make it 0
    @ if r3 = 0, make it 1
    EOR     r3, r3, #1
    B       loop
exit:
    MOV     r0, r1
    LDMFD   sp!, {r1-r10}
    BX      lr
