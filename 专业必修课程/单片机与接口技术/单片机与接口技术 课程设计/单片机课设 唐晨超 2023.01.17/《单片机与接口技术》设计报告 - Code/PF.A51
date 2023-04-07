PUMP:
    MOV 10H,#10D    ; 设置每次执行程序走10次循环
CONT1:
    ; 样例假定主轴正转
    ; 启动主轴正转 
    MOV DPTR, 3FFDH  ; 选中 PB 口地址并将电机正转口置为1
    MOV A, #80H
    MOVX @DPTR, A

    ; 延时，使驱动电路光耦合器导通
    NOP
    NOP

    MOV DPTR, 3FFDH
    MOV A, #0B0H
    MOVX @DPTR, A    
    MOV 11H, #4EH
    MOV 12H, #20H   ; 设置两脉冲之间延时20000us
    CALL DELAY      ; 延时，体现正转方向性
    DJNZ 10H, CONT1 ; 循环数减1，若非0则继续，共循环10次
    MOV DPTR, #5FFFH
    MOV @DPTR, A
    CALL DELAY1

    ; 启动ADC0809转换，并读取结果
    ; 设定用户压力数据存放在外部RAM Addr 字节处
    MOVX A, @DPTR    
    MOV R0, #Addr
    MOVX B, @R0
    SUBB A, B
    CJNE A, #00H, FEEDBACK
    CLR P1.5    ; 标志位清零
    JMP KEYS    ; 调压完成
FEEDBACK: 
    JNB ACC.7, CONT2  
    JMP CONT1    
CONT2:  
    MOV DPTR, 3FFDH
    MOV A, #00H
    MOVX @DPTR, A
    NOP
    NOP            
    MOV DPTR, 3FFDH
        MOV A, #40H
    MOVX @DPTR, A
    MOV 11H, #4EH
    MOV 12H, #20H
    CALL DELAY1
    DJNZ 10H, CONT2    
    MOV DPTR, #5FFFH
    MOV @DPTR, A    
    CALL DELAY
    MOVX A, @DPTR      
    MOV R0, #01H
    MOVX B, @R0
    SUBB A, B
    CJNE A, #00H, FEEDBACK
    CLR P1.5
    JMP CONT1
