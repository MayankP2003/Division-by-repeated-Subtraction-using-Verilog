`timescale 1ns / 1ps

module division_using_successive_substraction(LdA, LdB, LdD, clrCount, s, incCount, lesser, data_in, clk);
input LdA, LdB, clrCount, incCount, clk, s, LdD;
input [15:0] data_in;
output lesser;

wire [15:0] x, y, z, a, bout;
PIPO1 A(x, z, s, LdA, data_in, clk);
PIPO2 B(y, LdB, data_in, clk);
SUB SU(z, x, y);
comp Z(lesser, z, y);
count Count(bout, incCount, clrCount, y, clk);
PIPO2 D(a, LdD, z, clk);
endmodule

module PIPO1(x, z, s, ld, data, clk);
input clk, ld, s;
input [15:0] data, z;
output reg [15:0] x;

always @(posedge clk) begin
    if(!s & ld) x <= data;
    else if (s & ld) x <= z;
    else x <= x;
end
endmodule

module PIPO2(out, ld, data, clk);
input clk, ld;
input [15:0] data;
output reg [15:0] out;

always @(posedge clk) begin
    if(ld) out <= data;
    else out <= out;
end
endmodule

module SUB(out, in1, in2);
input [15:0] in1, in2;
output [15:0] out;
assign out = in1 - in2;
endmodule

module comp (out, value, ref);
input [15:0] value, ref;
output out;
assign out = (value < ref);
endmodule

module count(count, inc, clr, in, clk);
input [15:0] in;
input clk, inc, clr;
output reg [15:0] count;
always @(posedge clk) begin
    if (clr) count <= 16'b0;
    else if (inc) count <= count + 1;
    else count <= count;
end
endmodule



module controller(LdA, LdB, LdD, clrCount, incCount, lesser, start, done, clk);
input lesser, clk, start;
output reg LdA, LdB, clrCount, incCount, done, LdD;
reg [2:0] state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;
always @(posedge clk) begin
    case(state)
    S0: if(start) state <= S1;
    S1: #2 state <= S2;
    S2: state <= S3;
    S3: state <= S4;
    S4: begin if(lesser) state <= S5;
        else state <= S3; end
    S5: state <= S5;
    default: state <= S0; 
   endcase
end
always @(*) begin
    case(state)
    S0: begin LdA = 0; LdB = 0; LdD = 0; clrCount = 0; incCount = 0; done = 0; end
    S1: begin LdA = 1; LdB = 0; LdD = 0; clrCount = 0; incCount = 0; done = 0; end
    S2: begin LdA = 0; LdB = 1; LdD = 0; clrCount = 1; incCount = 0; done = 0; end
    S3: begin LdA = 0; LdB = 0; LdD = 1; clrCount = 0; incCount = 0; done = 0; end
    S4: begin LdA = 1; LdB = 0; LdD = 0; clrCount = 0; incCount = 1; done = 0; end
    S5: begin LdA = 0; LdB = 0; LdD = 0; clrCount = 0; incCount = 0; done = 1; end
    default: begin LdA = 0; LdB = 0; LdD = 0; clrCount = 0; incCount = 0; done = 0; end
    endcase
end
