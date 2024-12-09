module Mul_Add_Shift_Output(
    input wire iClk_12M,
    input wire iRsn,
    input wire iEnAcc,
    input signed [15:0] iShift,
    input signed [2:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff1,
    input signed [15:0] iCoeff2,
    input signed [15:0] iCoeff3,
    input signed [15:0] iCoeff4,
    input signed [15:0] iCoeff5,
    input signed [15:0] iCoeff6,
    input signed [15:0] iCoeff7,
    input signed [15:0] iCoeff8,
    input signed [15:0] iCoeff9,
    input signed [15:0] iCoeff10,
    input signed [15:0] iCoeff11,
    input signed [15:0] iCoeff12,
    input signed [15:0] iCoeff13,
    input signed [15:0] iCoeff14,
    input signed [15:0] iCoeff15,
    input signed [15:0] iCoeff16,
    input signed [15:0] iCoeff17,
    input signed [15:0] iCoeff18,
    input signed [15:0] iCoeff19,
    input signed [15:0] iCoeff20,
    input signed [15:0] iCoeff21,
    input signed [15:0] iCoeff22,
    input signed [15:0] iCoeff23,
    input signed [15:0] iCoeff24,
    input signed [15:0] iCoeff25,
    input signed [15:0] iCoeff26,
    input signed [15:0] iCoeff27,
    input signed [15:0] iCoeff28,
    input signed [15:0] iCoeff29,
    input signed [15:0] iCoeff30,
    input signed [15:0] iCoeff31,
    input signed [15:0] iCoeff32,
    input signed [15:0] iCoeff33,
    output reg signed [15:0] oFirOut // 16-bit Output
);
    reg signed [15:0] rShift [1:32];   // Shift registers
    wire signed [15:0] wMul [1:33];    // Multiplier outputs
    integer j, k;                     // Loop variables, declared outside of always block

    /*****************************/
    // Multiplier Logic
    /*****************************/
    always @(posedge iClk_12M or negedge iRsn) begin
        if (!iRsn) begin
            // Reset all shift registers
            for (j = 1; j <= 32; j = j + 1) begin
                rShift[j] <= 0;
            end
        end else if (iEnAcc) begin
            rShift[1] <= iShift + wMul[1]; // First register gets the FIR input
            // Shift and accumulate the result
            for (k = 32; k >= 2; k = k - 1) begin
                rShift[k] <= rShift[k - 1] + wMul[k];
            end
            oFirOut <= rShift[32];  // Output the accumulated result
        end
    end
endmodule
