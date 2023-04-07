; 对用户数据存储 SRAM 6264 进行间接寻址方式的读写
; 将寄存器 A 中的数据写入 #data

; 写入程序
MOV DPTR, #data ; #data 为需要写入的地址，16 位立即数，下同
MOVX A, @DPTR

; 读取程序
MOV DPTR, #data
MOVX @DPTR, A