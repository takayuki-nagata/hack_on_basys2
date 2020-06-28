//sum = SWs
@KBD
D=M
@sum
M=D
@i
M=0
(LOOP)
//print sum on SSEGs
@sum
D=M
@SCREEN
M=D
//light up LEDs with i
@i
D=M
@SCREEN
A=A+1
M=D
//wait foor pushing any BTN
(BTNWAIT1)
@KBD
A=A+1
D=M
@BTNWAIT1
D;JEQ
//wait for releasing the BTN
(BTNWAIT2)
@KBD
A=A+1
D=M
@BTNWAIT2
D;JNE
//for i=0; 100-i != 0; i++
@100
D=A
@i
D=D-M
@END
D;JEQ
@i
M=M+1
@i
D=M
//sum = sum+i
@sum
M=D+M
@LOOP
0;JMP
