`timescale 1ps/1ps


module sc_computer_sim;

    reg           resetn_sim;
    wire           clock_50M_sim;
	 reg           mem_clk_sim;
	 reg    [31:0] in_port0_sim;
	 reg    [31:0] in_port1_sim;

	 

    wire   [6:0]  hex0_sim,hex1_sim,hex2_sim,hex3_sim,hex4_sim,hex5_sim;
	 wire          led0_sim,led1_sim,led2_sim,led3_sim;
	 
	       
//	 wire   [31:0]  in_port0_sim,in_port1_sim;
	 
	 wire   [31:0]  pc_sim,inst_sim,aluout_sim,memout_sim;
    wire           imem_clk_sim,dmem_clk_sim;
    wire   [31:0]  out_port0_sim,out_port1_sim,out_port2_sim;
    wire   [31:0]  mem_dataout_sim;            // to check data_mem output
    wire   [31:0]  data_sim;
    wire   [31:0]  io_read_data_sim;
   
    wire           wmem_sim;   // connect the cpu and dmem. 

    //sc_computer    sc_computer_instance (resetn_sim,clock_50M_sim,mem_clk_sim,pc_sim,inst_sim,aluout_sim,memout_sim,
	                                      //imem_clk_sim,dmem_clk_sim,in_port0_sim,in_port1_sim,out_port0_sim,out_port1_sim,hex0_sim,hex1_sim,hex2_sim,hex3_sim);//,out_port0_sim,out_port1_sim,in_port0_sim,in_port1_sim,
													  //mem_dataout_sim,data_sim,io_read_data_sim          );
    sc_computer    sc_computer_instance (resetn_sim,mem_clk_sim,in_port0_sim,in_port1_sim,out_port0_sim,out_port1_sim,out_port2_sim,hex0_sim,hex1_sim,hex2_sim,hex3_sim,hex4_sim,hex5_sim);
// module sc_computer (resetn,clock,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk,out_port0,out_port1,in_port0,in_port1,mem_dataout,data,io_read_data);

/* input resetn,clock,mem_clk;
   
   input [31:0] in_port0,in_port1;
   
   output [31:0] pc,inst,aluout,memout;
   output        imem_clk,dmem_clk;
   output [31:0] out_port0,out_port1;
   output [31:0] mem_dataout;            // to check data_mem output
   output [31:0] data;
   output [31:0] io_read_data;
   
   wire   [31:0] data;
   wire          wmem;   // connect the cpu and dmem. 
*/




										
	/*
	 initial
        begin
            clock_50M_sim = 1;
            while (1)
                #2  clock_50M_sim = ~clock_50M_sim;
        end
  */
	   
	 initial
        begin
            mem_clk_sim = 1;
            while (1)
                #1  mem_clk_sim = ~ mem_clk_sim;
        end

	   	  
		  
		  
	 initial
        begin
            resetn_sim = 0;
            while (1)
                #5 resetn_sim = 1;
        end
	 



	 initial
    begin
      in_port0_sim = 4'b1001;
      in_port1_sim = 4'b0011;
    end
	 	  
		  
    initial
        begin
		  
          $display($time,"resetn=%b clock_50M=%b  mem_clk =%b", resetn_sim, clock_50M_sim, mem_clk_sim);
			 
			 # 125000 $display($time,"out_port0 = %b  out_port1 = %b ", out_port0_sim,out_port1_sim );

        end

endmodule 

