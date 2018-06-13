/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module pl_computer (resetn,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk,
      out_port0, out_port1, in_port0, in_port1,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
   
   input resetn,mem_clk;
   input [9:0] in_port0, in_port1;
   output [31:0] pc,inst,aluout,memout,out_port0, out_port1;
   output        imem_clk,dmem_clk;
   output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
   wire   [31:0] data;
   // wire mem_clk;
   wire wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
   reg clk;
   always @(posedge mem_clk)
   begin
      clk = ~clk;
   end
   // assign mem_clk = mem_clk;

   sevenseg seg0(out_port0[3:0],HEX0);
   sevenseg seg1(out_port0[7:4],HEX1);
   sevenseg seg2(out_port0[11:8],HEX2);
   sevenseg seg3(out_port0[15:12],HEX3);
   sevenseg seg4(out_port0[19:16],HEX4);
   sevenseg seg5(out_port0[23:20],HEX5);

   pipe_cpu cpu (clk,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
   sc_instmem  imem (pc,inst,clk,mem_clk,imem_clk);                  // instruction memory.
   sc_datamem  dmem (aluout,data,memout,wmem,clk,mem_clk,dmem_clk,resetn, out_port0, out_port1, in_port0, in_port1); // data memory.
   //module sc_datamem (addr,datain,dataout,we,mem_clk,mem_clk,dmem_clk,clrn, out_port0,out_port1,in_port0,in_port1,mem_dataout,io_read_data); 

endmodule

module  sevenseg ( data, ledsegments); 
   input [4:0] data;
   output ledsegments;
   reg [6:0] ledsegments; 
   always @ (*)
      case(data) 
         4'h0: ledsegments = 7'b100_0000; 
         4'h1: ledsegments = 7'b111_1001; 
         4'h2: ledsegments = 7'b010_0100;
         4'h3: ledsegments = 7'b011_0000;
         4'h4: ledsegments = 7'b001_1001;
         4'h5: ledsegments = 7'b001_0010;
         4'h6: ledsegments = 7'b000_0010;
         4'h7: ledsegments = 7'b111_1000;
         4'h8: ledsegments = 7'b000_0000;
         4'h9: ledsegments = 7'b001_0000;
         4'ha: ledsegments = 7'b100_1000;
         4'hb: ledsegments = 7'b000_0011;
         4'hc: ledsegments = 7'b100_0110;
         4'hd: ledsegments = 7'b010_0001;
         4'he: ledsegments = 7'b000_0110;
         4'hf: ledsegments = 7'b001_1110;
      default: ledsegments = 7'b111_1111;
      endcase
endmodule