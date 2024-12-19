/*********************************************************************
  - Project          : Direct form vs Transposed form
  - File name        : ReConf_FirFilter_Direct.v
  - Description      : Direct form Top module 
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.12.10 : Initial release
*********************************************************************/
module FIRFilter_Direct(
	input iClk_12M,
	input iRsn,
	input iCoeffiUpdateFlag,
	input iCsnRam,
	input iWrnRam,
	input [5:0] iAddrRam,
	input signed [15:0] iWrDtRam,
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);

	integer i;
	wire wEnAcc;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam;
	wire wWrnRam;
	wire [5:0] wAddrRam;
	wire signed [15:0] wWrDtRam;
	wire signed [15:0] wRdDtRam;
	
	reg  [15:0] rCoeff [1:33];




	//SpSram instance 
    SpSram_Param_Direct #(16,33) SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam),
        .iWrnRam(wWrnRam),
        .iAddrRam(wAddrRam),
        .iWrDtRam(wWrDtRam),
        .oCoeff1(rCoeff[1]),
        .oCoeff2(rCoeff[2]),
        .oCoeff3(rCoeff[3]),
        .oCoeff4(rCoeff[4]),
        .oCoeff5(rCoeff[5]),
        .oCoeff6(rCoeff[6]),
        .oCoeff7(rCoeff[7]),
        .oCoeff8(rCoeff[8]),
        .oCoeff9(rCoeff[9]),
        .oCoeff10(rCoeff[10]),
        .oCoeff11(rCoeff[11]),
        .oCoeff12(rCoeff[12]),
        .oCoeff13(rCoeff[13]),
        .oCoeff14(rCoeff[14]),
        .oCoeff15(rCoeff[15]),
        .oCoeff16(rCoeff[16]),
        .oCoeff17(rCoeff[17]),
        .oCoeff18(rCoeff[18]),
        .oCoeff19(rCoeff[19]),
        .oCoeff20(rCoeff[20]),
        .oCoeff21(rCoeff[21]),
        .oCoeff22(rCoeff[22]),
        .oCoeff23(rCoeff[23]),
        .oCoeff24(rCoeff[24]),
        .oCoeff25(rCoeff[25]),
        .oCoeff26(rCoeff[26]),
        .oCoeff27(rCoeff[27]),
        .oCoeff28(rCoeff[28]),
        .oCoeff29(rCoeff[29]),
        .oCoeff30(rCoeff[30]),
        .oCoeff31(rCoeff[31]),
        .oCoeff32(rCoeff[32]),
        .oCoeff33(rCoeff[33])
    );
	
	//FSM
	Controller_Direct Controller(
		.iClk_12M(iClk_12M),
        .iRsn(iRsn),
		.iCsnRam(iCsnRam),
        .iWrnRam(iWrnRam),
        .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
        .iAddrRam(iAddrRam),
		.iWrDtRam(iWrDtRam),

        .oEnDelay(wEnDelay), //10개
        .oEnAcc(wEnAcc),
        .oWrDtRam(wWrDtRam),
        .oAddrRam(wAddrRam),
        .oWrnRam(wWrnRam),
        .oCsnRam(wCsnRam)
	);

//역할 : iFirIn과 coeff 10개를 동시에 곱해서 shift register까지 구현해서 계속 넘기면서 출력값은 wire로 출력 
	Cal_Shift_Output_Direct MAS_1(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnAcc(wEnAcc),
		.iFirIn(iFirIn),
		.iCoeff1(rCoeff[1]),
		.iCoeff2(rCoeff[2]),
		.iCoeff3(rCoeff[3]),
		.iCoeff4(rCoeff[4]),
		.iCoeff5(rCoeff[5]),
		.iCoeff6(rCoeff[6]),
		.iCoeff7(rCoeff[7]),
		.iCoeff8(rCoeff[8]),
		.iCoeff9(rCoeff[9]),
		.iCoeff10(rCoeff[10]),
		.iCoeff11(rCoeff[11]),
		.iCoeff12(rCoeff[12]),
		.iCoeff13(rCoeff[13]),
		.iCoeff14(rCoeff[14]),
		.iCoeff15(rCoeff[15]),
		.iCoeff16(rCoeff[16]),
		.iCoeff17(rCoeff[17]),
		.iCoeff18(rCoeff[18]),
		.iCoeff19(rCoeff[19]),
		.iCoeff20(rCoeff[20]),
		.iCoeff21(rCoeff[21]),
		.iCoeff22(rCoeff[22]),
		.iCoeff23(rCoeff[23]),
		.iCoeff24(rCoeff[24]),
		.iCoeff25(rCoeff[25]),
		.iCoeff26(rCoeff[26]),
		.iCoeff27(rCoeff[27]),
		.iCoeff28(rCoeff[28]),
		.iCoeff29(rCoeff[29]),
		.iCoeff30(rCoeff[30]),
		.iCoeff31(rCoeff[31]),
		.iCoeff32(rCoeff[32]),
		.iCoeff33(rCoeff[33]),
		.oFirOut(oFirOut)
	);

endmodule
	
	
	
	