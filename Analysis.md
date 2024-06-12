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


LW,SW:
    offset的值，和存在reg_file的值相關。
    因為存在DMem的資料是32 bits，因此address是word aligned.
    所以base(reg1)+offset=target address of DMem.
    如果reg_file內的值是4的倍數,那instruction給的offset就必須為4的倍數
    而如果對應的reg值不是4的倍數，那instruction給的offset可以不是4的倍數。
    總結: offset可以非4的倍數也可以是負的，但對應的reg_file的reg值必須要相符，兩者加起來的target address必須是4的倍數。
    https://stackoverflow.com/questions/56373476/is-it-possible-to-have-a-negative-not-multiple-of-4-offset-in-a-load-store-inst

SW:
                  |     |     |      |     |      |     
AC810004    1010_1100_1000_0001_0000_0000_0000_0100     sw 'reg2_addr', 'offset(reg1_addr)'
    sw(101011), reg1_addr(00100), reg2_addr(00001), offset(4)   
reg_addr:    00100          00001
reg_data:    00000020       00000014
             base_address 

base_addr + extended_offset = taret_DMem_addr = 00000020 + 00000004 = 00000024
位址: 00000024 / 4 = 9, DMem idx[9]此時儲存的資料是00003400，
reg2_data = DMem_write_data 而這個操作會把00003400取代成00000014
在這一T讀到的是原本的資料

LW:
                  |     |     |      |     |      |   
8C240008    1000_1100_0010_0100_0000_0000_0000_1000     lw 'reg1_addr', 'offset(reg2_addr)'
    lw(100011), reg1_addr(00001), reg2_addr(00100), offset(8)
reg_addr:   00001               00100
reg_data:   00000014            xxxxxx
       DMem_read_base_addr    RegFile_write_target_addr

base_addr + extended_offset = taret_DMem_addr = 00000014 + 00000008 = 0000001C
位址: 0000001C / 4 = 7, DMem idx[7]此時儲存資料是00002C00
讀出來寫回去RegFile的target address(reg2_addr): 00100 存到RF idx [4]

BEQ:
                  |     |     |      |     |      |   
10210001    0001_0000_0010_0001_0000_0000_0000_0001     beq 'reg1_addr', 'reg2_addr', 'next+offset'
    beq(000100), reg1_addr(00001), reg2_addr(00001), offset(1)
reg_addr:   00001               00001
reg_data:   00000014            00000014 

ALU比較reg1和reg2的值(用sub), 所以alu_result是0的話，就代表要branch,
要將instruction 的branch target address送回pc，
branch instruction target address = next_ins_number + offset
offset=1 --> 跳到下2個instruction
所以pc的值會更新: next_ins_number + offset*4 = (3+1)*4 + (1)*4 = 16 = (5)*4，
會跳到instruction idx[5]，因此instruction idx[4]也就是下一個instruction不會被執行

ADD: 被branch了
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
08000003    0000_1000_0000_0000_0000_0000_0000_0100     j 'absolute address'
jump(000010), address(26'h4)
jump到instruction idx[4]
所以接下來會 instruction: idx[4] -> idx[5] -> idx[6] -> idx[4] -> idx[5] -> idx[6] ... forever

</code></pre>

