lbi r1, 100	//load 100 into r1
lbi r2, 99	//load 99 into r2
nop
nop
nop
add r3, r1, r2	//expected r3 = 199 or x00c7
nop
nop
halt

