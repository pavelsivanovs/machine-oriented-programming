        .text
        .align  2
        .global asum
        .type   asum, %function
asum:
        MOV     r9, lr  @ saglabājam sākotnējo LR vērtību
        MOV     r1, #1  @ R1 būs summa
        MOV     r2, #1  @ R2 būs pieskaitāmais pie summas

        CMP     r0, #1
        BLT     error           @ pie n < 1 mēs atgriežam 0, jo dati ir nekorekti
        BLE     return_1        @ pie n = 1 mēs atgriežam 1, jo arit. progresijā ir tikai viens loceklis 1, un to summa ir 1
        B       loop

return_1:
        MOV     r1, #1
        B exit

error:
        MOV     r1, #0
        B       exit

loop:
        ADD     r2, r2, #1
        ADD     r1, r1, r2
        CMP     r2, r0
        BLT     loop

exit:
        MOV     r0, r1
        BX      r9