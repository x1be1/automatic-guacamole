module top_module (
    input clk,
    input reset,       
    output reg [3:0] q);
    always @(posedge clk) begin
        if(reset)begin
            q<=4'd0;
        end
        else begin
            if(q==4'd9)  q<=4'd0;
            else         q<=q+4'd1;
        end
    end
endmodule
/*module top_module(
	input clk,
	input reset,
	output reg [3:0] q);
	
	always @(posedge clk)
		if (reset || q == 9)  
            q<=0;
		else
			q <= q+1;
	
endmodule
