; 样例假定主轴正转
; 启动主轴正转
MOV DPTR, #3FFDH; 把 82C55 PB 口的地址送入 DPTR 
MOV A, #7FH     ; 将正转口置为0，同时反转口置为1启动继电器
MOVX @DPTR, A

; 启动T1计数器对转速传感器发生的脉冲计数
; 调用延时函数
SETB TR1
CALL DELAY10ms

; 延时结束后读取TL1的值，即可得出脉冲数量。注意，使用1900rpm的电机，
; 每秒最大转速为31转，50ms产生62个脉冲，不会超出T1计数器工作方式2的计数极限
; 所以正常情况下使用工作方式2不会产生计数溢出，T1计数器只用于计数，不会中断。
RPM:
    MOV A, TL1
    MOV B, A
    MOV R1, $Addr   ; $Addr 为假定的转速保存地址
    MOVX R2, @R1

    ; 调速判断部分
    ; 若差为0，则证明转速调节完毕，不需跳转，继续进行
    ; 否则跳转至FEEDBACK程序
    SUBB A, R2
    CJNE A, #00H, FEEDBACK
    CLR P1.6                 
    JMP KEYS

FEEDBACK2:
    ; 若差为正数，则跳转至SLOWER程序段
    JNB ACC.7, SLOWER

    ; 若差为负数，则跳转到QUICKER程序
    CPL ACC.7                
    JMP QUICKER

QUICKER:
    ; 使用之前保存的现速度减去超出部分速度，得到调节速度存入寄存器B
    ;将调节速度的数字量传送给DAC0832以调节输出脉冲频率
    SUBB B, A
    MOV DPTR #7FFFH         
    MOV A, B
    MOVX @DPTR, A
    JMP FORWARD

SLOWER:
    ADD B, A
    MOV DPTR, #7FFFH
    MOV A, B
    MOVX @DPTR, A
    JMP FORWARD
    