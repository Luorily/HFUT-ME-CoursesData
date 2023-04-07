URGENT:
    MOV DPTR, 3FFEH
    MOV A, @DPTR    ; 中断服务子程序首先读取PC口状态
    CHEAK:
        JNB ACC.4,BPQ   ; 若变频器故障则PC.4位为零，转移至相应子程序
        JNB ACC.5,GLQ   ; 若过滤器故障则PC.5位为零，转移至相应子程序
        JMP $           ; 等待故障处理
    BPQ:
        MOV A #11H
        JMP CHEAK       ; 若变频器故障则输出A为11H用于示错
    GLO:
        MOV A #22H
        JMP CHEAK       ; 若过滤器故障则输出A为22H用于示错
