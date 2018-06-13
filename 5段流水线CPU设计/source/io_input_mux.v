module io_input_mux(a0,a1,sel_addr,y);     
    input   [31:0]  a0,a1;     
    input   [ 5:0]  sel_addr;     
    output  [31:0]  y;     
    reg     [31:0]  y;         
    always @ *     
    case (sel_addr) 
 
       6'b110000: y = a0;        
       6'b110001: y = a1;               
       // more ports，可根据需要设计更多的端口。         
       endcase 
endmodule  
