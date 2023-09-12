package com.vietsens.txe.txe_pos_integrate;

import static android.content.ContentValues.TAG;

import android.util.Log;

import com.vanstone.trans.api.IcApi;
import com.vanstone.trans.api.SystemApi;
import com.vanstone.trans.api.struct.ApduResp;
import com.vanstone.trans.api.struct.ApduSend;
import com.vanstone.utils.CommonConvert;

public class IcCardIsoProcessor {
    // CardNo = 0; ic card
    // CardNo = 1 or 2; PSAM card
    public String ExecuteCommand(int CardNo) {
        byte[] RstBuf = new byte[128];
        byte[] Rlen = new byte[8];
        int haveCard = 0;
        int Ret = 0;
        int Timerid = SystemApi.TimerSet_Api();
        int Timerid2 = -1;
        int count = 0;

        Ret = IcApi.IccInit_Api(CardNo, 3, RstBuf, Rlen);
        Log.e(TAG, "ic init Ret = " + Ret);

        while (true) {
            if (SystemApi.TimerCheck_Api(Timerid, 30 * 1000) == 1) {
                return "time out no ic card";
            }
            if (Timerid2 == -1 || SystemApi.TimerCheck_Api(Timerid2, 1000) == 1) {
                Log.e(TAG, "Secound Jump " + count);
                count++;
                Timerid2 = SystemApi.TimerSet_Api();
            }
            if (IcApi.IccDetect_Api(CardNo) == 0) {
                Log.e(TAG, "IccDetect_Api Has Ic Card!!");
                if (CardNo == 0) //ic card
                    haveCard = 1;
                else haveCard = 2;//psam card
                break;
            }
        }
        if (haveCard == 1) {

            Ret = IcApi.IccInit_Api(CardNo, 3, RstBuf, Rlen);
            Log.e(TAG, "IccInit_Api= " + Ret);
            if (Ret != 0) {
                return ("IccInit_Api error = " + Ret);
            }
            Ret = IcApi.IccGetCardType_Api();
            Log.e(TAG, "IccGetCardType_Api= " + Ret);


            ApduSend send = new ApduSend();
            ApduResp recv = new ApduResp();
            send.Command[0] = (byte) 0x00;
            send.Command[1] = (byte) 0xa4;
            send.Command[2] = (byte) 0x04;
            send.Command[3] = (byte) 0x01;
            send.Lc = 14;
            //1PAY.SYS.DDF01
            byte[] DataIn = new byte[]{0x31, 0x50, 0x41, 0x59, 0x2E, 0x53, 0x59, 0x53, 0x2E, 0x44, 0x44, 0x46, 0x30, 0x31};
            System.arraycopy(DataIn, 0, send.DataIn, 0, send.Lc);
            send.Le = 256;
            IcApi.IccIsoCommand_Api(CardNo, send, recv);
            if (recv.readCardDataOk == 1) {
                Log.e(TAG, "IccIsoCommand get APDU");
                byte[] result = new byte[64];
                result[0] = recv.sWA;
                result[1] = recv.sWB;
                Log.e(TAG, ("swa=" + (recv.sWA & 0xff) + "swb=" + recv.sWB+ ",dataOut=" + CommonConvert.bytes2HexString(recv.dataOut)));
                return ("swa=" + (recv.sWA & 0xff) + "swb=" + recv.sWB);
            }
            return ("IccIsoCommand_Api error");
        } else if (haveCard == 2) {
            ApduSend send = new ApduSend();
            ApduResp recv = new ApduResp();
            send.Command[0] = (byte) 0x00;
            send.Command[1] = (byte) 0x84;
            send.Command[2] = (byte) 0x04;
            send.Command[3] = (byte) 0x00;
            send.Lc = 0;
            send.Le = 255;
            IcApi.IccIsoCommand_Api(CardNo, send, recv);
            if (recv.readCardDataOk == 1) {
                Log.e(TAG, "IccIsoCommand get APDU");
                byte[] result = new byte[64];
                result[0] = recv.sWA;
                result[1] = recv.sWB;
                return ("swa=" + (recv.sWA & 0xff) + "swb=" + recv.sWB);
            }
            return ("IccIsoCommand_Api Psam error");
        }
        return "Ic Card Test End";
    }

}
