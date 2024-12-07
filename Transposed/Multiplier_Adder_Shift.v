module Multiplier_Adder_Shift(
    input iClk_12M,
    input iRsn,
    input iEnSample_300k,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iFirIn,        // FIR input
    input signed [15:0] iCoeff,       // 16-bit Coefficient
    output reg signed [15:0] oMac         // 16-bit Output
);
    reg [15:0] rShift [1:10];
    wire signed [15:0] wMul [1:10];

    /*****************************/
    // Multiplier Logic using generate block
    /*****************************/
    genvar i;
    generate
        for (i = 1; i <= 10; i = i + 1) begin : multiplier
            assign wMul[i] = iFirIn * iCoeff;
        end
    endgenerate

    /*****************************/
    // Sequential Logic for Transposed FIR Filter
    /*****************************/
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            // Reset all shift registers
            integer j;
            for (j = 1; j <= 10; j = j + 1) begin
                rShift[j] <= 0;
            end
            oMac <= 0;
        end else if (iEnSample_300k) begin
            rShift[0] <= iFirIn; // First register gets the FIR input
            integer k;
            for (k = 10; k >= 1; k = k + 1) begin
                rShift[k] <= rShift[k-1] + wMul[k];
            end
        end
    end

    /*****************************/
    // Output Assignment
    /*****************************/
endmodule
