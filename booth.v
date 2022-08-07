module reg4(input wire clk,reset,load,input wire [3:0]din,output wire [3:0]r);
	genvar i;
 	 generate for(i = 0; i < 4; i=i+1) begin:array_loop
	      dfrl dfp(clk, reset, load, din[i], r[i]); end
	 endgenerate	
endmodule

module mux2_4(input wire [3:0]i0,i1, input wire s,output wire [3:0] opm);
	genvar i;
 	 generate for(i = 0; i < 4; i=i+1) begin:mux_loop
	      mux2 mx(i0[i],i1[i],s,opm[i]); end
	 endgenerate
endmodule

module booth_alu(input wire clk, qt, qtn, input wire[3:0] a, b, output wire [3:0] o);
	wire s;
	xor2 cp(qt, qtn, s);
	wire cout;
	wire [3:0] out;
	addsubfull as(a, b, qt, out, cout);
	mux2_4 mx1(a, out, s , o);
endmodule


module booth_cu(input wire clkin, reset, output wire clk, endflag);
	wire [1:0] op;
	wire temp, ain, dfpin, dfpin1,clk0,clk1;
	dfrl1 reset1(clkin, reset, 1'b1, 1'b0, dfpin);
	downctr Dctr(clkin, reset, ain, op);
	or3 oc0(dfpin, op[1], op[0], ain);
	and2 ad0(clkin, ain, clk);
	invert inv(ain, endflag);
endmodule

module booth(input wire clkin, reset, input wire [3:0] a, b, output wire [7:0] out);
	wire clk, endflag;
	booth_cu cu0(clkin, reset, clk, endflag);
	
	wire [3:0]Qin, Qout, ACout, o1, o2, ALUout;
	wire qtpin, qtp, temp;
	
	dfr qtpr(clk, reset, qtpin, qtp);
	reg4 AC(clk, reset, 1'b1, o1, ACout);
	mux2_4 resetmux2(o2, b, reset, Qin);
	reg4 Q(clk, 1'b0, 1'b1, Qin, Qout);
	
	booth_alu alu0(clk, Qout[0], qtp, ACout, a, ALUout);
	
	RSA ashr1(ALUout, o1,temp);
	RSAio ashr2(Qout, temp, o2, qtpin);
	
	wire [3:0] float;
	
	mux2_4 mxAC(float, ACout, endflag, out[7:4]);
	mux2_4 mxQ(float, Qout, endflag, out[3:0]);

endmodule
