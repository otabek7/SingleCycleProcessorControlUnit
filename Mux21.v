module Mux21(out, in, sel);
    input [1:0] in;
    input sel;
    output out;

    wire notSel, out1, out2;

    not not0(notSel, sel);
    and and0(out1, notSel, in[0]);
    and and1(out2, sel, in[1]);
    or or0(out, out1, out2);

endmodule