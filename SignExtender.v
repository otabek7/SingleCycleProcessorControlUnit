module SignExtender(BusImm, Imm26, Ctrl); 
   output reg[63:0] BusImm; 
   input [25:0]  Imm26; 
   input 	[2:0] Ctrl; 
   reg 	 extBit;

   //assign extBit = (Ctrl ? 2'b11 : Imm26[25]); 

   always@(*)
     begin
         case (Ctrl)
            3'b000: begin
               extBit = (Imm26[21]); // I-type 11+11 = 100 111+11= 00
                BusImm = {{52{extBit}}, Imm26[21:10]}; 
            end

         3'b001: begin
               extBit = (Imm26[20]); // D-type
               BusImm = {{55{extBit}}, Imm26[20:12]}; 
            end

            3'b010: begin
               extBit = (Imm26[25]); // B
                BusImm = {{38{extBit}}, Imm26[25:0]}; 
            end

            3'b011: begin
               extBit = (Imm26[23]); // CBZ
                BusImm = {{45{extBit}}, Imm26[23:5]}; 
            end

            3'b100: begin

               //BusImm = Imm26[20:5] << (Imm26[22:21]*16);
               case (Imm26[22:21])
                  2'b00: begin BusImm = {48'b0, {Imm26[20:5]}}; end // shift by 0
                  2'b01: begin BusImm = {32'b0, {Imm26[20:5]}, 16'b0}; end // shift by 16
                  2'b10: begin BusImm = {16'b0, {Imm26[20:5]}, 32'b0}; end // shift by 32
                  
                  2'b11: begin BusImm = {Imm26[20:5], 48'b0};
                  $display("immmm", Imm26); end // shift by 48
               endcase
            end
      endcase
  end
   
endmodule