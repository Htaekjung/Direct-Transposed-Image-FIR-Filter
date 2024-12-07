/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ACC.v
  - Description      : MAC(Multiply + Add + Accumulate) w/ 10 taps
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/

module Multiplier_Adder_Shift(
    input iClk_12M,
    input iRsn,
    input iEnSample_600k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iCoeff,  // 16-bit Coefficient

    output signed [15:0] oMac    // 16-bit Output
);

    /*****************************/
    // reg declaration
    /*****************************/
    reg signed [15:0] rAccOut;    // Accumulated Value
    reg signed [15:0] rMul;       // Current Multiplier Output
    reg        [15:0] rVal;       // Intermediate Accumulated Value
    reg signed [15:0] wAccOut;    // Current Accumulation Result
    /*****************************/
    // wire declaration
    /*****************************/
wire signed [15:0] wMul [1:10];

// Multiplier Logic using generate block
genvar i;
generate
    for (i = 1; i <= 10; i = i + 1) begin : multiplier
        assign wMul[i] = iFirIn * iCoeff;
    end
endgenerate

    /*****************************/
    // Accumulation Logic
    // /*****************************/
    // always @(*) begin
    //     case (iEnMul)
    //         4'b0001: rMul = wMul1;
    //         4'b0010: rMul = wMul2;
    //         4'b0011: rMul = wMul3;
    //         4'b0100: rMul = wMul4;
    //         4'b0101: rMul = wMul5;
    //         4'b0110: rMul = wMul6;
    //         4'b0111: rMul = wMul7;
    //         4'b1000: rMul = wMul8;
    //         4'b1001: rMul = wMul9;
    //         4'b1010: rMul = wMul10;
    //         default: rMul = 16'h0; // Default to 0 for invalid iEnMul
    //     endcase
    // end

    	// Accumulator 동작
	always@(*) begin
		if(!iRsn) begin
			wAccOut <= 16'h0;
		end else if(iEnAdd) begin
			wAccOut <= rVal + rMul;
		end
		else begin
			wAccOut <= 16'h0;
		end
	end

	always @(*) begin
		if(!iRsn) begin
		rVal  <= 16'h0;
		end
		else if(iEnMul == 1'b1) begin
			rVal <= 16'h0;		
			end
	
		
		else begin
			rVal <= rAccOut;
		end
	end
		
	//Coefficient값이 지금 다 unsigned로 구현해서 -> signed로 구현하는거  
	always @(posedge iClk_12M) begin
		if(!iRsn) 
		begin
			rAccOut <= 16'h0;
		end
		else begin
			if(iEnAcc) rAccOut  <= wAccOut;
		end
	end




    /*****************************/
    // Output Assignment
    /*****************************/
    assign oMac = rAccOut;

endmodule
