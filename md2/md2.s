        .text
        .align  2
        .global matmul
        .type   matmul, %function
matmul:
        @ r0 - h1
        @ r1 - w1
        @ r2 - *m1
        @ r3 - h2
        @ w2 - [sp]
        @ m2 - [sp,#-4]
        @ m3 - [sp,#-8]
        @ check if w1 == h2. if not equal return 1
        CMP     r1, r3
        BNE     exit_with_error

        @ remembering the values of r4-r12
        STMFD   sp, {r4-r12,lr}

        @ initialization of iterators for m3
        @ r7 iterates from 1..h1
        @ r8 iterates form 1..w2
        MOV     r7, #0
        MOV     r8, #0

loop_row:
        CMP     r7, r0
        @ if r7 has reached h1
        BEQ     exit_without_error

loop_column:
        LDR     r4, [sp]        @ w2
        CMP     r8, r4
        BLT     multiply_cell

        @ if r8 has reached w2:
        MOV     r8, #0
        ADD     r7, r7, #1
        B       loop_row 

multiply_cell:
        @ multiply_cell calcualtes dot product for m3 based on row r7 of m1 and column r8 of m2.
        @ the dot product of m1 row and m2 column is stored at r9
        @ during the process of calculation r10 is used for temporary values
        @ r11 is used for iterating in m1 rows
        @ r12 is used for iterating in m2 columns

        @ setting r11 to show at correct row of m1
        MUL     r11, r1, r7
        MUL     r11, r11, #4    @ because int is 4 bytes long
        ADD     r11, r2, r11

        @ setting r12 to show at correct column of m2
        LDR     r4, [sp,#-4]    @ m2
        MUL     r12, r8, #4     @ because int is 4 bytes long
        ADD     r12, r4, r12

        @ dot_product preparations
        MOV     r9, #0          @ starting sum is 0
        LDR     r4, [sp]        @ w2
        MUL     r4, r4, #4      @ setting r4 to be equal to the distance of m2 cell to the cell below
        MOV     r5, #0  @ r5 is used as loop counter for dot_product
dot_product:
        MUL     r10, [r11], [r12]
        ADD     r11, r11, #4
        ADD     r12, r12, r4
        ADD     r9, r9, r10
        ADD     r5, r5, #1
        CMP     r5, r1  @ checking if dot product is completed
        BLT     dot_product

        @ now we need to write r9 value to matrix m3 at row r7 column r8
        @ r5 will store that address
        LDR     r4, [sp]        @ w2
        LDR     r6, [sp,#-8]    @ m3
        MUL     r5, r7, r4      @ setting the row & columns offset
        ADD     r5, r8
        ADD     r6, r6, r5      @ r6 shows at r7,r8 cell of m3
        STR     r9, [r6]

        @ increasing the iterator r8
        ADD     r8, r8, #1
        B       loop_column

exit_without_error:
        MOV     r0, #0
        ADD     sp, sp, #32
        LDMFD   sp, {r4-r12,pc}
exit_with_error:
        MOV     r0, #1
        BL      lr
