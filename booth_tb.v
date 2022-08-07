`timescale 1 ns / 100 ps
`define TESTVECS 6

module tb;
  reg clk, reset;
  reg [3:0] a, b;
  wire [7:0] out;
  wire o;
  integer i;
  initial begin $dumpfile("booth.vcd"); $dumpvars(0,tb); end
  initial begin reset = 1'b1; #10 reset = 1'b0; end
  initial clk = 1'b0; always #5 clk =~ clk;
  initial begin
  a <= 4'd6;
  b <= 4'd4;
  end
  booth m1(clk, reset, a, b, out);
  initial begin
  	#200 $finish;
  end
endmodule	
