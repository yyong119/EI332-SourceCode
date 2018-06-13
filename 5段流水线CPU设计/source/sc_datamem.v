module sc_datamem (addr,datain,dataout,we,clock,mem_clk,dmem_clk,clrn, out_port0,out_port1,in_port0,in_port1); 
 
    input  [31:0]   addr;
    input  [31:0]   datain;    
    input          we, clock,mem_clk,clrn;    
    input  [9:0]   in_port0,in_port1;        
    output [31:0]    dataout;    
    output         dmem_clk;    
    output [31:0]    out_port0,out_port1;    
    wire [31:0]    mem_dataout;    
    //output [31:0]    io_read_data;        
    wire [31:0]        io_read_data;        
    wire [31:0]     dataout;    
    wire           dmem_clk;         
    wire          write_enable;     
    wire          wrire_datamem_enable;    
    assign        dmem_clk = mem_clk & ( ~ clock) ;  //注意    
    assign        write_enable = we & ~clock;        //注意    
    assign        write_datamem_enable = write_enable & ( ~ addr[7]);    //注意    
    assign        write_io_output_reg_enable = write_enable & ( addr[7]);  //注意        
    mux2x32  mem_io_dataout_mux(mem_dataout,io_read_data,addr[7],dataout); 
    // module mux2x32 (a0,a1,s,y);
    // that is, the address space of datamem is from 000000 to 011111 word(4 bytes)????
    // assign        write_datamem_enable = write_enable;    //注意    
    // assign        write_io_output_reg_enable = write_enable & 0;  //注意        
    // mux2x32  mem_io_dataout_mux(mem_dataout,io_read_data,0,dataout); 
    lpm_ram_dq_dram  dram(addr[6:2],dmem_clk,datain,write_datamem_enable,mem_dataout );  
    io_output_reg io_output_regx2 (addr,datain,write_io_output_reg_enable, dmem_clk,clrn,out_port0,out_port1); 
    // module io_output_reg (addr,datain,write_io_enable,io_clk,clrn,out_port0,out_port1 ); 
    io_input_reg io_input_regx2(addr,dmem_clk,io_read_data,in_port0,in_port1); 
    // module io_input_reg (addr,io_clk,io_read_data,in_port0,in_port1);
endmodule
