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
        @ m2 - [sp,#4]
        @ m3 - [sp,#8]
        @ check if w1 == h2. if not equal return 1, because matrices cannot be multiplied
        CMP     r1, r3
        BNE     exit_with_error

        @ remembering the values of r0-r10
        STMFD   sp, {r0-r10}

        @ initialization of iterators for m3
        @ r7 iterates from 0..h1 excl.
        @ r8 iterates form 0..w2 excl.
        MOV     r7, #0
        MOV     r8, #0

loop_row:
        LDR     r0, [sp,#-4]    @ h1
        CMP     r7, r0

        @ if r7 has reached h1
        BEQ     exit_without_error

loop_column:
        LDR     r0, [sp]        @ w2
        CMP     r8, r0

        @ if r8 still has not reached w2
        BLT     multiply_cell

        @ if r8 has reached w2:
        MOV     r8, #0
        ADD     r7, r7, #1
        B       loop_row 

multiply_cell:
        @ multiply_cell calcualtes dot product for m3 based on row r7 of m1 and col r8 of m2.
        @ the dot product of m1 row and m2 col is stored at r9
        @ during the process of calculation r10 is used for temporary values
        @ r2 is used for iterating in m1 rows
        @ r3 is used for iterating in m2 cols

        @ setting r2 to show at correct row of m1
        LDR     r0, [sp,#-8]    @ w1
        MUL     r1, r0, r7
        MOV     r0, #4
        MUL     r2, r1, r0      @ because int is 4 bytes long
        LDR     r0, [sp,#-12]   @ m1
        ADD     r2, r0, r2      @ adding an offset to m1 address to point at the first cell of r7 row of m1

        @ setting r3 to show at correct col of m2
        LDR     r0, [sp,#4]     @ m2
        MOV     r5, #4
        MUL     r3, r8, r5      @ because int is 4 bytes long
        ADD     r3, r0, r3      @ adding an offset to m2 address to point at the first cell of r8 col of m2

        @ dot_product preparations
        @ r9 keeps the dot product of the row and the col
        @ r6 is used for exiting the dot_product loop
        MOV     r9, #0          @ starting sum is 0
        MOV     r6, #0          @ dot_product iter variable 
dot_product:
        @ gradual calculation of dot product
        LDR     r4, [r2]        
        LDR     r5, [r3]
        MUL     r10, r4, r5     @ multiplying one term of dot product
        ADD     r9, r9, r10

        @ changing the r2, r3 to show at next cells
        LDR     r4, [sp]        @ w2
        MOV     r5, #4
        MUL     r0, r4, r5      @ setting r0 to be equal to the distance of m2 cell to the cell below
        ADD     r2, r2, #4      @ setting r2 to be the address of a next cell in a row in m1
        ADD     r3, r3, r0      @ setting r3 to be the address of a next cell in a col in m2

        @ check if we should continue dot_product multiplication
        ADD     r6, r6, #1
        LDR     r0, [sp,#-8]    @ w1 - equals to the num of terms in dot product
        CMP     r6, r0          @ checking if dot product is completed
        BLT     dot_product

        @ now we need to write r9 value to matrix m3 at row r7 col r8
        @ r3 will store that address
        LDR     r1, [sp,#-4]    @ h1
        LDR     r2, [sp]        @ w2
        LDR     r3, [sp,#8]     @ m3
        MUL     r4, r2, r7      @ r4 offsets to correct row
        ADD     r4, r4, r8      @ r4 offsets to correct row and col
        MOV     r1, #4
        MUL     r2, r4, r1      @ because cell size is 4 bytes
        ADD     r3, r3, r2      @ r6 shows at r7,r8 cell of m3
        STR     r9, [r3]

        @ increasing the iterator r8
        ADD     r8, r8, #1
        B       loop_column

exit_without_error:
        ADD     sp, sp, #44
        LDMFD   sp!, {r0-r10}
        MOV     r0, #0
        BX      lr
exit_with_error:
        MOV     r0, #1
        BX      lr
