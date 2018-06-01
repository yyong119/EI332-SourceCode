/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (resetn,mem_clk,in_port0,in_port1,out_port0,out_port1,out_port2,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
   
	//input resetn,clock,mem_clk;
	input resetn, mem_clk;
	wire clock;
	input [3:0]  in_port0, in_port1;
	//output [31:0] pc,inst,aluout,memout;
	wire [31:0] pc,inst,aluout,memout;
	//output        imem_clk,dmem_clk;
	wire imem_clk, dmem_clk;
	output [31:0] 	out_port0, out_port1, out_port2;
	wire[31:0] out_port0, out_port1, out_port2;
	wire   [31:0] data;
	wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
	output wire [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

	half_frequency hf(resetn,mem_clk,clock);

	
	sc_cpu cpu (clock,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
	sc_instmem  imem (pc,inst,clock,mem_clk,imem_clk);                  // instruction memory.
	sc_datamem  dmem (aluout,data,memout,wmem,clock,mem_clk,dmem_clk,resetn,in_port0,in_port1,out_port0,out_port1,out_port2); // data memory.
	
	sevenseg s0(out_port0[3:0],HEX4);
	sevenseg s1(out_port0[7:4],HEX5);

	sevenseg s2(out_port1[3:0],HEX2);
	sevenseg s3(out_port1[7:4],HEX3);
	
	sevenseg s4(out_port2[3:0],HEX0);
	sevenseg s5(out_port2[7:4],HEX1);

endmodule

module half_frequency(resetn,mem_clk,clock);
	input resetn,mem_clk;
	output clock;
	reg clock;
	initial
	begin
		clock = 0;
	end
	always @(posedge mem_clk)
	begin
		if(~resetn)
			clock <= 0;
		clock <= ~clock;
	end
endmodule

module sevenseg(in,sevenseg);

input [3:0] in;
output [6:0] sevenseg;
reg [6:0] sevenseg;

initial
begin
	sevenseg = 0;
end

always @(*)
	begin
	case(in)
		4'h0: sevenseg[6:0] = 7'b1000000;
		4'h1: sevenseg[6:0] = 7'b1111001;
		4'h2: sevenseg[6:0] = 7'b0100100;
		4'h3: sevenseg[6:0] = 7'b0110000;
		4'h4: sevenseg[6:0] = 7'b0011001;
		4'h5: sevenseg[6:0] = 7'b0010010;
		4'h6: sevenseg[6:0] = 7'b0000010;
		4'h7: sevenseg[6:0] = 7'b1111000;
		4'h8: sevenseg[6:0] = 7'b0000000;
		4'h9: sevenseg[6:0] = 7'b0010000;
		4'hA: sevenseg[6:0] = 7'b0001000;
		4'hB: sevenseg[6:0] = 7'b0000011;
		4'hC: sevenseg[6:0] = 7'b1000110;
		4'hD: sevenseg[6:0] = 7'b0100001;
		4'hE: sevenseg[6:0] = 7'b0000110;
		4'hF: sevenseg[6:0] = 7'b0001110;
		default: sevenseg[6:0] = 7'b1111111;
	endcase
	end
endmodule

		