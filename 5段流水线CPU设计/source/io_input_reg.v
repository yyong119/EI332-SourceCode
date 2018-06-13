module io_input_reg (addr,io_clk,io_read_data,in_port0,in_port1); 

    input  [31:0]  addr; 
    input          io_clk; 
    input  [9:0]  in_port0,in_port1; 
    output [31:0]  io_read_data; 
 
    reg    [31:0]  in_reg0;     // input port0 
    reg    [31:0]  in_reg1;     // input port1 
 
    io_input_mux io_imput_mux2x32(in_reg0,in_reg1,addr[7:2],io_read_data); 
    wire [31:0] inport_temp;

    assign inport_temp = {22'b0000000000000000000000,in_port0};
    always @(posedge io_clk)  
    begin           
        in_reg0 <= inport_temp;   // 输入端口在 io_clk 上升沿时进行数据锁存           {22'b0,in_port0[9:0]}
        in_reg1 <= in_port1;   // 输入端口在 io_clk 上升沿时进行数据锁存 
 
    end 
endmodule  
 
 