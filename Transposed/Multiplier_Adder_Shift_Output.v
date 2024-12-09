module Mul_Add_Shift_Output(
    input iClk_12M,
    input iRsn,
    input iEnSample_300k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iShift,
    input signed [2:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff1,       // 16-bit Coefficient 1
    input signed [15:0] iCoeff2,       // 16-bit Coefficient 2
    input signed [15:0] iCoeff3,       // 16-bit Coefficient 3
    output reg signed [15:0] oFirOut         // 16-bit Output
);
    reg signed [15:0] rShift [1:3];   // Shift registers
    wire signed [15:0] wMul [1:3];    // Multiplier outputs
    integer j, k;                     // Loop variables, declared outside of always block

    /*****************************/
    // Multiplier Logic
    /*****************************/
    assign wMul[1] = iFirIn * iCoeff1;
    assign wMul[2] = iFirIn * iCoeff2;
    assign wMul[3] = iFirIn * iCoeff3;

    /*****************************/
    // Sequential Logic for Transposed FIR Filter
    /*****************************/
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            oFirOut <= 0;
            // Reset all shift registers
            for (j = 1; j <= 3; j = j + 1) begin
                rShift[j] <= 0;
            end
        end else if (iEnSample_300k) begin
            rShift[1] <= iShift + wMul[1]; // First register gets the FIR input
            // Shift and accumulate the result
            for (k = 3; k >= 2; k = k - 1) begin
                rShift[k] <= rShift[k - 1] + wMul[k];
            end
            oFirOut <= rShift[3];  // Output the accumulated result
        end
    end

endmodule
