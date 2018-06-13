module latch_idex (clrn,clk,enable,
                    in_wmem,in_wreg,in_regrt,in_m2reg,in_aluc,in_jal,
                    in_alua,in_alub,in_data,in_wn,in_res,in_p4,
                    out_wmem,out_wreg,out_regrt,out_m2reg,out_aluc,out_jal,
                    out_alua,out_alub,out_data,out_wn,out_res,out_p4
                    );

input           enable,clk,clrn;
input   [31:0]  in_alua,in_alub,in_p4,in_data; 
input   [4:0]   in_wn,in_res;
input   [3:0]   in_aluc;
input           in_wmem,in_wreg,in_regrt,in_m2reg,in_jal;        
output   [31:0]  out_alua,out_alub,out_p4,out_data; 
output   [4:0]   out_wn,out_res;
output   [3:0]   out_aluc;
output           out_wmem,out_wreg,out_regrt,out_m2reg,out_jal;        

reg   [31:0]  out_alua,out_alub,out_p4,out_data; 
reg   [4:0]   out_wn,out_res;
reg   [3:0]   out_aluc;
reg           out_wmem,out_wreg,out_regrt,out_m2reg,out_jal;     


always @(posedge clk or negedge clrn)         
begin           
    if (clrn == 0)               
    begin                 // reset                 
        out_wmem<=0;
        out_wreg<=0;
        out_regrt<=0;
        out_m2reg<=0;
        out_aluc<=0;
        out_jal<=0;
        out_alua<=0;
        out_alub<=0;
        out_wn<=0;
        out_res<=0;
        out_p4 <= 0;
        out_data<=0;
    end
    else
    begin                 
        if (enable == 1)
        begin                    
            out_wmem<=in_wmem;
            out_wreg<=in_wreg;
            out_regrt<=in_regrt;
            out_m2reg<=in_m2reg;
            out_aluc<=in_aluc;
            out_jal<=in_jal;
            out_alua<=in_alua;
            out_alub<=in_alub;
            out_wn<=in_wn;
            out_res<=in_res;   
            out_p4 <= in_p4;
            out_data <= in_data;
        end
        else
        begin 
            out_wmem = 0;
            out_wreg = 0;
        end 
    end      
end
endmodule

 