`timescale 1ps/1ps

module tb();

reg clk, rst_;

initial begin
    clk <= 0;
    forever #10 clk = ~clk;
end

initial begin
    rst_ <= 0;
    repeat (3) @(posedge clk);
    @(negedge clk);
    rst_ = 1;
end


MIPS_CPU cpu( clk, rst_);

initial #1000 $finish;

/* initial values to store in memory */
initial begin
     //data, startaddr, endaddr
    $readmemh("INST_to_store_in_Imem.txt", cpu.IMem.ROM); 
    $readmemh("REG_to_store_in_RegFile.txt", cpu.RegFile.RF);
    $readmemh("DATA_to_store_in_DMem.txt", cpu.DMem.RAM, 0, 63);
end

/* check instruction idx[0]: ADD */
initial begin
    //repeat (3) @(posedge clk);  
    //rst done
    @(posedge clk);  
    //instruction: ADD done (operate at begining, not controlled by reset)
    @(posedge clk);
    #1; //can check RegFile *add delay*
    $writememh("CHECK_RegFile_for_inst0_add.txt", cpu.RegFile.RF);
end

/* check instruction idx[1]: SW */
initial begin
    repeat (3) @(posedge clk);  
    //rst done
    @(posedge clk);  
    //instruction: SW done
    @(posedge clk);
    #1; //can check DMem *add delay*
    $writememh("CHECK_DMem_for_inst1_sw.txt", cpu.DMem.RAM, 0, 127);
                                        //top_CPU.data_mem.RAM
end

/* check instruction idx[2]: LW */
initial begin
    repeat (3) @(posedge clk);  
    //rst done
    repeat (2) @(posedge clk);  
    //instruction: LW done
    @(posedge clk);
    #1; //can check RegFile *add delay*
    $writememh("CHECK_RegFile_for_inst2_lw.txt", cpu.RegFile.RF);
end


/* check instruction idx[5]: SUB */
initial begin
    repeat (3) @(posedge clk);  
    //rst done
    repeat (4) @(posedge clk);  
    //instruction: SUB done 
    @(posedge clk);
    
    #1; //can check RegFile *add delay*
    $writememh("CHECK_RegFile_for_inst5_sub.txt", cpu.RegFile.RF);
end


/* check instruction idx[4]: ADD */
initial begin
    repeat (3) @(posedge clk);  
    //rst done
    repeat (6) @(posedge clk);  
    //instruction: ADD done 
    @(posedge clk);
    
    #1; //can check RegFile *add delay*
    $writememh("CHECK_RegFile_for_inst4_add.txt", cpu.RegFile.RF);
end



initial begin
    $dumpfile("wave.vcd");
    $dumpvars();
    //$fsdbDumpMDA();
end

endmodule 