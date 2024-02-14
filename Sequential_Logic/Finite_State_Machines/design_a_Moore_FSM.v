module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    parameter L1=4'b0001,B21=4'b0010,B32=4'b0100,A3=4'b1000;
    
    reg [3:0] state ,next_state;
    reg [2:0] fr;
    
    assign {fr3,fr2,fr1}=fr;
        
    always @(posedge clk) begin
        if(reset) state<=L1;
        else      state<=next_state;
    end
    
    always @(*) begin
        case(s)
            3'b000:next_state=L1;
            3'b001:next_state=B21;
            3'b011:next_state=B32;
            3'b111:next_state=A3;
            default:next_state=L1;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) fr<=3'b111;
        else
            case(next_state)
                L1 :fr<=3'b111;
                B21:fr<=3'b011;
                B32:fr<=3'b001;
                A3 :fr<=3'b000;
                default:fr<=3'b111;
            endcase
    end
    
    always @(posedge clk) begin
        if(reset)    dfr<=1'b1;
        else
            if(next_state<state)   dfr<=1'b1;
            else if(next_state>state)  dfr<=1'b0;
            else    dfr<=dfr;
    end

endmodule

/*module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);


	// Give state names and assignments. I'm lazy, so I like to use decimal numbers.
	// It doesn't really matter what assignment is used, as long as they're unique.
	// We have 6 states here.
	parameter A2=0, B1=1, B2=2, C1=3, C2=4, D1=5;
	reg [2:0] state, next;		// Make sure these are big enough to hold the state encodings.
	


    // Edge-triggered always block (DFFs) for state flip-flops. Synchronous reset.	
	always @(posedge clk) begin
		if (reset) state <= A2;
		else state <= next;
	end



    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
	always@(*) begin
		case (state)
			A2: next = s[1] ? B1 : A2;
			B1: next = s[2] ? C1 : (s[1] ? B1 : A2);
			B2: next = s[2] ? C1 : (s[1] ? B2 : A2);
			C1: next = s[3] ? D1 : (s[2] ? C1 : B2);
			C2: next = s[3] ? D1 : (s[2] ? C2 : B2);
			D1: next = s[3] ? D1 : C2;
			default: next = 'x;
		endcase
	end
	
	
	
	// Combinational output logic. In this problem, a procedural block (combinational always block) 
	// is more convenient. Be careful not to create a latch.
	always@(*) begin
		case (state)
			A2: {fr3, fr2, fr1, dfr} = 4'b1111;
			B1: {fr3, fr2, fr1, dfr} = 4'b0110;
			B2: {fr3, fr2, fr1, dfr} = 4'b0111;
			C1: {fr3, fr2, fr1, dfr} = 4'b0010;
			C2: {fr3, fr2, fr1, dfr} = 4'b0011;
			D1: {fr3, fr2, fr1, dfr} = 4'b0000;
			default: {fr3, fr2, fr1, dfr} = 'x;
		endcase
	end
	
endmodule
