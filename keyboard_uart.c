#include "xparameters.h"
#include "xgpiops.h"
#include <stdio.h>
#include "platform.h"
#include "xuartps.h"
#include "xil_printf.h"
#include <sleep.h>

//====================================================
XUartPs_Config *Config_0;
XUartPs Uart_PS_0;

#define NUM_OF_BYTE 1

XGpioPs gpiops;
XGpioPs_Config*GpioConfigPtr;


int main (void)
{
	  init_platform();
	  int Status;
	  u8 BufferPtr_rx[1];

	  int xStatus,in1_status;
	  int iPinNumberEMIO_RX = 54; // data sent to FPGA serial module on this port
	  u32 uPinDirectionEMIO_RX = 0x1; // output to serial module in FPGA

	  // PS GPIO Initialization
	  GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
	  if(GpioConfigPtr == NULL)
	    return XST_FAILURE;
	  xStatus = XGpioPs_CfgInitialize(&gpiops,
	      GpioConfigPtr,
	      GpioConfigPtr->BaseAddr);
	  if(XST_SUCCESS != xStatus)
	    print(" PS GPIO INIT FAILED \n\r");

	  // UART initialization
		Config_0 = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
		if (NULL == Config_0) {
			return XST_FAILURE;
		}
		Status = XUartPs_CfgInitialize(&Uart_PS_0, Config_0, Config_0->BaseAddress);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

	  for(int k=0;k<8;k++)
	  {
		  XGpioPs_SetDirectionPin(&gpiops,iPinNumberEMIO_RX+k,uPinDirectionEMIO_RX);
		  XGpioPs_SetOutputEnablePin(&gpiops, iPinNumberEMIO_RX+k, 1); // output to PL
		  XGpioPs_WritePin(&gpiops, iPinNumberEMIO_RX+k, 0);
	  }

	  print("\nHi the program has started.\n");
	  while (1)
	  {

			Status = 0;
			while (Status < NUM_OF_BYTE) {
				Status +=	XUartPs_Recv(&Uart_PS_0, BufferPtr_rx, (NUM_OF_BYTE - Status));
			}
			print("Received Character is: ");
			XUartPs_Send(&Uart_PS_0, BufferPtr_rx, NUM_OF_BYTE+2);
			printf(";\t Decimal representation of the character is: %u\n",BufferPtr_rx[0]);
			in1_status=BufferPtr_rx[0];

	        // array to store binary number
	        int binaryNum[8];
	        // counter for binary array
	        int i = 0;
	        while (in1_status > 0) {

	            // storing remainder in binary array
	            binaryNum[i] = in1_status % 2;
	            in1_status = in1_status / 2;
	            i++;
	        }

	        for (int j=0;j<8;j++)
	        {
		        XGpioPs_WritePin(&gpiops,iPinNumberEMIO_RX+j,binaryNum[j]);
	        }

	   }
}


