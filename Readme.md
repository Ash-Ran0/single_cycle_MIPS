## 32-bits MIPS: single cycle datapath 
#### Designed and implemented a single-clock cycle MIPS processor using Verilog, incorporating basic instructions such as lw, sw, add, sub, beq, and jump.
#### Constructed essential components including program counter, instruction memory, data memory, ALU, registers file, and controller.
#### Successfully compiled the entire Verilog codebase using Quartus II.


<pre><code>
### instructions:
#### I-type:
##### .lw:  load word           read from "data_mem",       load to "register_file"
##### .sw:  store word          read from "register_file",  store to "data_mem"
##### .beq: branch on equal     read from "register_file",  ALU compare 2 registers, control input to "program_counter"

#### R-type:    read from "register_file", send to ALU compute, store back to "register_file"
##### .add
##### .substract
##### .AND  
##### .OR
##### .set on less than

#### J-type:    jump to instruction using absolute instruction address
##### .jump

</code></pre>

### References
https://github.com/martinKindall/mips_cpu
https://github.com/Moustafa55589/MIPS-32-Bit-Single-Cycle-and-Pipelined-RTL-Design-using-verilog
https://github.com/ybch14/Single-Cycle-CPU-with-Verilog
https://github.com/walsvid/Single_Cycle_CPU


