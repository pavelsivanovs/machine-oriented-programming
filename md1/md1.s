        .text
        .align 2
        .global asum
asum:
        MOV r4, lr
        CMP r0, #0
        BLE error
        CMP r0, #1
        BLT exit

        ADD r1, r0, #1
        MOV r2, r0
        MOV r3, r1
        BL multiply
        LSR r0, r3, #1
        B exit

multiply:
        ADD r3, r1, r3
        SUB r2, r2, #1
        CMP r2, #1
        BGT multiply
        BX lr

error:
        MOV r0, #0

exit:
        MOV lr, r4
        BX lr