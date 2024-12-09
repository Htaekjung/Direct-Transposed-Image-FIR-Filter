module Mul_Add_Shift(
    input iClk_12M,
    input iRsn,
    input iEnAcc,
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
    input signed [2:0] iFirIn,       // FIR input

    output reg signed [15:0] oMac    // 16-bit Output
);

    reg signed [15:0] rShift [0:9];
    wire signed [15:0] wMul [0:9];
    integer k;  // Loop variable

    // Multiplier Logic
    assign wMul[0] = iFirIn * iCoeff1;
    assign wMul[1] = iFirIn * iCoeff2;
    assign wMul[2] = iFirIn * iCoeff3;
    assign wMul[3] = iFirIn * iCoeff4;
    assign wMul[4] = iFirIn * iCoeff5;
    assign wMul[5] = iFirIn * iCoeff6;
    assign wMul[6] = iFirIn * iCoeff7;
    assign wMul[7] = iFirIn * iCoeff8;
    assign wMul[8] = iFirIn * iCoeff9;
    assign wMul[9] = iFirIn * iCoeff10;

    // Sequential Logic for Transposed FIR Filter
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            oMac <= 0;
            // Reset all shift registers
            for (k = 0; k < 10; k = k + 1) begin
                rShift[k] <= 0;
            end
        end else if (!iEnAcc) begin
            // Shift logic and accumulation
            rShift[0] <= wMul[0];
            for (k = 1; k < 10; k = k + 1) begin
                rShift[k] <= rShift[k - 1] + wMul[k];
            end
            // Output the accumulated result
            oMac <= rShift[9];
        end
    end

endmodule
