    .text
    .align  2
    .global ep1
    .type   ep1, %function
ep1:
    STMFD   sp!, {r0-r10}    @ let's save everything in stack

    @ r0 - is the pointer at the beggining of the c-string 
    @ r1 - is the checksum
    @ r2 - is the byte read from r0
    @ r3 - is a flag for odd bytes

    MOV     r1, #0  @ initial checksum value
    MOV     r3, #1  @ first byte is odd
    SUB     r0, r0, #1  @ we will add that 1 later

loop:
    ADD     r0, r0, #1
    LDR     r2, [r0]

    @ check if it is a 0 byte
    CMP     r2, #0
    BEQ     exit

    @ r4 is the mask 
    @ r5 is the counter
    MOV     r4, #1
    MOV     r5, #0

    @ checking if we should count 0s or 1s
    CMP     r3, #1
    BEQ     count_ones

count_zeroes:
    @ if the byte is even
    @ counting all the 0s in byte with mask
    AND     r6, r2, r4
    CMP     r6, #0
    ADDEQ   r1, r1, #1
    ADD     r5, r5, #1
    LSL     r4, r4, #1
    CMP     r5, #8
    BLT     count_zeroes

    @ after even byte there goes the odd byte, as it should
    MOV     r3, #1
    B       loop
count_ones:
    @ the byte is odd
    @ we are counting 1s
    AND     r6, r2, r4
    CMP     r6, #1
    ADDEQ   r1, r1, #1
    ADD     r5, r5, #1
    LSL     r4, r4, #1
    CMP     r5, #8
    BLT count_ones

    @ after odd byte there goes the even byte, as it should
    MOV     r3, #0
    B       loop
exit:
    MOV     r0, r1
    ADD     sp, sp, #4
    LDMFD   sp!, {r1-r10}
    BX      lr
