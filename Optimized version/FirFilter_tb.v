/*********************************************************************
  - Project          : Direct form vs Transposed form
  - File name        : ReConf_FirFilter_tb.v
  - Description      : testbench
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
`timescale 1ns/10ps

module FirFilter_tb;

  /***********************************************
  // Wire & Register Declarations
  ***********************************************/
  // Input signals
  reg iClk_12M;
  reg iRsn;
  reg iEnSample_300k;
  reg iCoeffiUpdateFlag;
  reg iCsnRam;
  reg iWrnRam;
  reg [5:0] iAddrRam;
  reg signed [15:0] iWrDtRam;
  reg signed [15:0] iFirIn;
  // Output signal
  wire signed [15:0] oFirOut;
  // Instantiate the DUT (Device Under Test)
  FIRFilter_Direct Direct (
    .iClk_12M(iClk_12M),
    .iRsn(iRsn),
    .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
    .iCsnRam(iCsnRam),
    .iWrnRam(iWrnRam),
    .iAddrRam(iAddrRam),
    .iWrDtRam(iWrDtRam),
    .iFirIn(iFirIn),
    .oFirOut(oFirOut)
  );

    FirFilter_Transposed Transposed (
    .iClk_12M(iClk_12M),
    .iRsn(iRsn),
    .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
    .iCsnRam(iCsnRam),
    .iWrnRam(iWrnRam),
    .iAddrRam(iAddrRam),
    .iWrDtRam(iWrDtRam),
    .iFirIn(iFirIn),
    .oFirOut(oFirOut)
  );

  /***********************************************
  // Clock Generation
  ***********************************************/
  initial
  begin
    iClk_12M     <= 1'b0;
  end
  always   begin
    // 12MHz clock
    #(83.333/2) iClk_12M <= ~iClk_12M;
  end

  /***********************************************
  // Reset Sequence
  ***********************************************/
  initial
  begin
    iRsn = 1'b1;
    repeat (  5) @(posedge iClk_12M);

    iRsn = 1'b0;
    repeat (  2) @(posedge iClk_12M);
    $display("--------------------------------------->");
    $display("**** Active low Reset released !!!! ****");
    iRsn = 1'b1;
    $display("--------------------------------------->");
  end


  /***********************************************
  // 600kHz sample enable making
  ***********************************************/

  // initial begin
  //   #20
  //   repeat (150) begin
  //     iEnSample_300k <= 1'b1;
  //     #83.333;  // 83.333ns, HIGH 상태 지속 시간
  //     iEnSample_300k <= 1'b0;
  //     #3250;    // 3250ns, LOW 상태 지속 시간
  //   end
  // end


  /***********************************************
  // Switch control
  ***********************************************/
  initial
  begin
    iFirIn  <= 16'b000;
    $display("------------------------------------------------->");
    $display("OOOOO 3'b001 is received from testbench  !!! OOOOO");
    $display("------------------------------------------------->");

    repeat (107) @(posedge iClk_12M);
    @(posedge iClk_12M);
    iFirIn  <= 16'b001;
    repeat (1) @(posedge iClk_12M);
    iFirIn  <= 16'b000;
    repeat (100) @(posedge iClk_12M);
  end

  /***********************************************
  // Predefined Coefficients (iWrDtRam 설정)
  ***********************************************/
  reg [15:0] coeff [0:11]; // Coefficient array for all ranges

initial begin
    coeff[1]  = 16'h0003;//양수
    coeff[2]  = 16'h0006;//음수
    coeff[3]  = 16'h0007;//양수
    coeff[4]  = 16'h000B;//음수
    coeff[5]  = 16'h000D;//양수
    coeff[6]  = 16'h0013;//음수
    coeff[7]  = 16'h0018;//양수
    coeff[8]  = 16'h0025;//음수
    coeff[9]  = 16'h0030;//양수
    coeff[10] = 16'h0066;//음수
    coeff[11] = 16'h00CE;//양수
    coeff[12] = 16'h01F4;//양수
end

  integer i, j, k; // 'integer'는 올바르게 선언됨

  /**********************************/
  //iAddr 설정
  /**********************************/
  initial begin
    repeat(41) @(posedge iClk_12M);

      for (i = 1; i <= 33; i = i + 1) begin
          @(posedge iClk_12M);
          iAddrRam = i; // Address within 0 to 9 for each RAM
          iWrDtRam = coeff[iAddrRam-1];
      end
      for (i = 1; i <= 34; i = i + 1) begin
          @(posedge iClk_12M);
          iAddrRam = i; // Address within 0 to 9 for each RAM
      end
  end



/************************************/
//FSM
/************************************/
initial begin
    // 초기화
    iCoeffiUpdateFlag = 0;
    iCsnRam = 1;
    iWrnRam = 1;
    iAddrRam = 0;
    iWrDtRam = 0;
    // 테스트 단계
    // 0. p_Idle 상태
    repeat (41) @(posedge iClk_12M);
    $display("TEST: p_Idle 상태로 전환");


    iCoeffiUpdateFlag = 1; // 계수 업데이트 플래그 설정
    iCsnRam = 0; 
    iWrnRam = 0; // RAM 활성화
    iAddrRam = 0;
    // 1. p_Write 상태
    repeat (33) @(posedge iClk_12M);
    
    $display("TEST: p_SpSram 상태로 전환");
    // repeat (34) begin
      iWrnRam = 1; 
      iCsnRam = 0;
      iCoeffiUpdateFlag = 0;
      // 2. p_Read 상태
      $display("TEST: p_Acc 상태로 전환");
        repeat (34) @(posedge iClk_12M);
        iCsnRam = 1;
        // 3. p_Output 상태
        repeat (50) @(posedge iClk_12M);
        $display("TEST: p_Sum 상태로 전환");
    //end
    #100; // 최종 출력 확인
    $stop; // 시뮬레이션 종료
end
endmodule
