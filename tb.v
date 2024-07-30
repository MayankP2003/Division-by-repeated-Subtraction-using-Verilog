`timescale 1ns / 1ps
module tb;
reg  clk, start, s;
reg [15:0] data_in;
wire done;

division_using_successive_substraction I1 (.LdA(LdA), .LdB(LdB), .LdD(LdD), .clrCount(clrCount), .incCount(incCount), .clk(clk), .data_in(data_in), .lesser(lesser), .s(s));
controller I2(.LdA(LdA), .LdB(LdB), .LdD(LdD), .clrCount(clrCount), .incCount(incCount), .clk(clk), .lesser(lesser), .start(start), .done(done));

// CLOCK generation
initial begin clk <= 0; s<=0; end
always #5 clk <= ~clk;

initial begin
    //$monitor($time,": ",
    #5 start <= 0;
    #7 start <= 1;
    data_in <= 15'd100;
    #20 data_in <= 15'd3;
    s <= 1;
    #1500 $finish; 
end
endmodule
