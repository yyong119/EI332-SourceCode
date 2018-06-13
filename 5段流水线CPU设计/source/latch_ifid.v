module latch_ifid (clrn,clk,enable,flush,in_ins,in_p4,out_ins,out_p4); 

input   [31:0]  in_ins,in_p4; 
input           enable,clk;
input           clrn;
input           flush;        

output  [31:0]  out_ins,out_p4; 
 
reg     [31:0]  out_ins,out_p4;  


always @(posedge clk or negedge clrn)         
begin           
    if (clrn == 0)               
    begin                 // reset                 
        out_ins <= 0; 
        out_p4 <= 0;
    end
    else
    begin 
		if(flush==1)
		begin 
			out_ins <=0; 
			out_p4<=0;
		end
        else
        begin
            if (enable == 1)
            begin                    
                out_ins <= in_ins;          
                out_p4 <= in_p4;
            end
        end
	end
end

endmodule
 