module bubblecontrol (rs,rt,wn,wreg,m2reg,imme,freeze);

   input [4:0] rs,rt,wn;
   input wreg, m2reg,imme;
   output freeze;
   reg freeze;
   always @(*)
   begin
     if((rs==wn || rt==wn && ~imme )&& wreg && m2reg)
        begin
        freeze = 1;
        end else begin
          freeze = 0;
        end
   end
   
endmodule
