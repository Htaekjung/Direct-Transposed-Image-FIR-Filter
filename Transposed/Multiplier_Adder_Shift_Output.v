module Mul_Adder_Shift_2(
    input iClk_12M,
    input iRsn,
    input iEnSample_300k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iShift,
    input signed [15:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff,       // 16-bit Coefficient
    output reg signed [15:0] oMac         // 16-bit Output
);
    reg [15:0] rShift [1:3];
    wire signed [15:0] wMul [1:3];

    /*****************************/
    // Multiplier Logic using generate block
    /*****************************/
    assign wMul[1] = iFirIn * iCoeff;
    assign wMul[2] = iFirIn * iCoeff;
    assign wMul[3] = iFirIn * iCoeff;

    /*****************************/
    // Sequential Logic for Transposed FIR Filter
    /*****************************/
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            oMac <= 0;
            // Reset all shift registers
            integer j;
            for (j = 1; j <= 10; j = j + 1) begin
                rShift[j] <= 0;
            end
        end else if (iEnSample_300k) begin
            rShift[1] <= iShift + wMul[1]; // First register gets the FIR input
            integer k;
            for (k = 3; k >= 2; k = k + 1) begin
                rShift[k] <= rShift[k-1] + wMul[k];
            end
            oMac <= rShift[3] + wMul[3];
        end
    end

endmodule
