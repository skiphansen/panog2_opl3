
#ifndef OPL3_FPGA_H
#define OPL3_FPGA_H


/****************** Include Files ********************/
// #include "xil_types.h"
#include "xstatus.h"


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a OPL3_FPGA register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the OPL3_FPGAdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 *    void OPL3_FPGA_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define OPL3_FPGA_mWriteReg(BaseAddress, RegOffset, Data) Opl3WriteReg(0,RegOffset,Data);

/**
 *
 * Read a value from a OPL3_FPGA register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the OPL3_FPGA device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 *    u32 OPL3_FPGA_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define OPL3_FPGA_mReadReg(BaseAddress, RegOffset)

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the OPL3_FPGA instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus OPL3_FPGA_Reg_SelfTest(void * baseaddr_p);

#endif // OPL3_FPGA_H
