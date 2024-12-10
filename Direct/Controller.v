/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : Controller.v
  - Description      : Controller w/FSM
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.12.10 : Initial release
*********************************************************************/
module Controller(
    input iClk_12M,
    input iRsn,
    input iCsnRam,
    input iWrnRam,
    input iCoeffiUpdateFlag,
    input [5:0] iAddrRam,
    input signed [15:0] iWrDtRam,
    output oEnAcc,
    output oCsnRam,                 //SpSram write read에 사용
    output oWrnRam,                 //SpSram write read에 사용
    output signed [15:0] oWrDtRam,  //Coefficient 값
    output [5:0] oAddrRam,          //SpSram write read에 사용
    output oEnDelay
);
    parameter p_Idle = 3'b000,
              p_Write = 3'b001,
              p_Read = 3'b010,
              p_Output = 3'b011;

    reg [2:0] rCurState;
    reg [2:0] rNxtState;
    reg [3:0] Selection;
    reg rEnAccDelay;

    // Current state update
    always @(posedge iClk_12M) begin
        if (!iRsn)
            rCurState <= p_Idle;
        else
            rCurState <= rNxtState;
    end

    // Next state decision
    always @(*) begin
        case (rCurState)
            p_Idle://0
                rNxtState <= (iCoeffiUpdateFlag && !iCsnRam && !iWrnRam) ? p_Write : p_Idle;

            p_Write://SpSram write - 1
                rNxtState <= (!iCoeffiUpdateFlag && iWrnRam) ? p_Read : p_Write;

            p_Read://Spsram Read - 2
                rNxtState <= (iCsnRam) ? p_Output : p_Read;

            p_Output://3
            if (iCoeffiUpdateFlag == 0 && iCsnRam == 0 && iWrnRam == 1) begin
                rNxtState <= p_Read;  // iCoeffiUpdateFlag = 0, iCsnRam = 0, iWrnRam = 1일 때 p_Read로 전이
            end else if (iCoeffiUpdateFlag == 1 && iCsnRam == 1 && iWrnRam == 0) begin
                rNxtState <= p_Idle;  // iCoeffiUpdateFlag = 1, iCsnRam = 1, iWrnRam = 0일 때 p_Idle로 전이
            end else begin
                rNxtState <= p_Output;   // 나머지 경우는 p_Output 상태 유지
            end


            default:
                rNxtState <= p_Idle;
        endcase
    end

    // Control signals
    assign oCsnRam = ((rCurState == p_Write) || rCurState == p_Read) ? 1'b0 : 1'b1;

    assign oWrnRam = (rCurState == p_Write) ? 1'b0 : 1'b1;

    assign oAddrRam = ((rCurState == p_Write)  || rCurState == p_Read) ? iAddrRam : 4'b0000;

    assign oWrDtRam = (rCurState == p_Write) ? iWrDtRam : 16'b0;

    // Enable delay signal
    assign oEnDelay = (rCurState == p_Idle || rCurState == p_Write) ? 1'b0 : 1'b1;



    // Control signal for Add and Accumulator delay
always @(posedge iClk_12M) begin
    if (!iRsn) begin
        rEnAccDelay <= 1'b0;
    end else begin
        if (rCurState == p_Read || rCurState == p_Output) begin
            rEnAccDelay <= 1'b1;
        end else begin
            rEnAccDelay <= 1'b0;
        end
    end
end
    // Output enable signals for Adders, Accumulators, and Multipliers
    assign oEnAcc = rEnAccDelay;

endmodule
