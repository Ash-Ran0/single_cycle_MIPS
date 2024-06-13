### instructions

<pre><code>
I-format:
            inst[31:26]     inst[25:21]     inst[20:16]     inst[15:0]     
lw          100011          reg1_addr       write_addr      offset-> ALU   
sw          101011          reg1_addr       reg2_addr       offset-> ALU   
beq         000100          reg1_addr       reg2_addr       offset-> ALU   
addi
subi

R-format:
            inst[31:26]     inst[25:21]     inst[20:16]     inst[15:11]     inst[10:6]      inst[5:0]    
add         000000          reg1_addr       reg2_addr       write_addr      x               funct: 100000   -> ALU_control
sub         000000          reg1_addr       reg2_addr       write_addr      x               funct: 100010   -> ALU_control

J-format:
            inst[31:26]     inst[25:0] 
j           000010          absolute_inst_addr
</code></pre>


<pre><code>
ADD:
                  |     |     |      |     |      |
003E1820    0000_0000_0011_1110_0001_1000_0010_0000     add 'write_addr', 'reg1_addr', 'reg2_addr'
r-type(000000), reg1_addr(00001), reg2_addr(11110), write_addr(00011), funct(100000):add
reg_addr:    00001   11110       00011
reg_data: 00000014 + 00000048 = 0000005C
                                write to RegFile


SW:
                  |     |     |      |     |      |     
AC810004    1010_1100_1000_0001_0000_0000_0000_0100     sw 'reg2_addr', 'offset(reg1_addr)'
    sw(101011), reg1_addr(00100), reg2_addr(00001), offset(4)   
reg_addr:    00100          00001
reg_data:    00000020       00000014
             base_address 


LW:
                  |     |     |      |     |      |   
8C240008    1000_1100_0010_0100_0000_0000_0000_1000     lw 'reg1_addr', 'offset(reg2_addr)'
    lw(100011), reg1_addr(00001), reg2_addr(00100), offset(8)
reg_addr:   00001               00100
reg_data:   00000014            xxxxxx
       DMem_read_base_addr    RegFile_write_target_addr



BEQ:
                  |     |     |      |     |      |   
10210001    0001_0000_0010_0001_0000_0000_0000_0001     beq 'reg1_addr', 'reg2_addr', 'next+offset'
    beq(000100), reg1_addr(00001), reg2_addr(00001), offset(1)
reg_addr:   00001               00001
reg_data:   00000014            00000014 


ADD: xx branched
                  |     |     |      |     |      |   
000FB820    0000_0000_0000_1111_1011_1000_0010_0000     add 'write_addr', 'reg1_addr', 'reg2_addr'
r-type(000000), reg1_addr(00000), reg2_addr(01111), write_addr(10111), funct(100000):add
reg_addr:    00000          01111       10111
reg_data: zero_register +   00000018 = 00000018
                                        write to RegFile

SUB:
                  |     |     |      |     |      |   
00E17822    0000_0000_1110_0001_0111_1000_0010_0010     sub 'write_addr', 'reg1_addr', 'reg2_addr'
r-type(000000), reg1_addr(00111), reg2_addr(00001), write_addr(01111), funct(100010):sub
reg_addr:   00111               00001               01111
reg_data:   0000002c     -      00000014        =   00000018
                                                    write to RegFile

JUMP:
                  |     |     |      |     |      |   
08000004    0000_1000_0000_0000_0000_0000_0000_0100     j 'absolute address'
jump(000010), address(26'h4)
next: instruction: idx[4] -> idx[5] -> idx[6] -> idx[4] -> idx[5] -> idx[6] ... forever

</code></pre>

