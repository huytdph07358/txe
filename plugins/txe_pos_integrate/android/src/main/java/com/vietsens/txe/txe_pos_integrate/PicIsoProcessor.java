package com.vietsens.txe.txe_pos_integrate;

import static android.content.ContentValues.TAG;

import android.util.Log;

import com.vanstone.appsdk.api.cards.ICHandler;
import com.vanstone.appsdk.client.SdkApi;
import com.vanstone.trans.api.IcApi;
import com.vanstone.trans.api.MagCardApi;
import com.vanstone.trans.api.PiccApi;
import com.vanstone.trans.api.SystemApi;
import com.vanstone.trans.api.constants.CoreDefConstants;
import com.vanstone.trans.api.constants.EmvLibConstants;
import com.vanstone.trans.api.jni.JCallback;
import com.vanstone.trans.api.struct.ApduResp;
import com.vanstone.trans.api.struct.ApduSend;
import com.vanstone.utils.CommonConvert;

public class PicIsoProcessor {
    private boolean sloted_card = true;
    private String card_no;
    public String piccIso() {
        String resultData ="";
        byte[] CardType = new byte[2], SerialNo = new byte[20];
        int ret = 1;

        try{
            MagCardApi.MagOpen_Api();
            MagCardApi.MagReset_Api();
            ret = PiccApi.PiccOpen_Api();
        } catch (Exception e){
            e.printStackTrace();
        }

        Log.e("vanstone", "picc open ret = " + ret);
        if (ret != 0) return resultData;

        byte[] RstBuf = new byte[128];
        byte[] Rlen = new byte[8];

        while (sloted_card == true) {
            int timerid = 0;
            timerid = SystemApi.TimerSet_Api();
            boolean cardflag = false, iccardflag = false, picccardflag = false;
            byte[] CardData = new byte[1024];
            byte[] usCardLenAddr = new byte[4];
            while (SystemApi.TimerCheck_Api(timerid, 40 * 1000) == 0) {
                cardflag = false;
                iccardflag = false;
                picccardflag = false;
                if (MagCardApi.MagRead_Api(CardData, usCardLenAddr) == 0x31) {
                    cardflag = true;
                }
                if (!cardflag && IcApi.IccDetect_Api(0) == 0x00) {
                    iccardflag = true;
                }
                if (!cardflag
                        && !iccardflag
                        && PiccApi.PiccCheck_Api(0, CardType, SerialNo) == 0) {
                    picccardflag = true;
                }
                if (cardflag) {
                    String trackData =  CommonConvert.bytes2HexString(CardData);
                    Log.e("cardflag.trackData=", trackData);
                    if(!trackData.isEmpty()) {
                        resultData = trackData;
                        sloted_card = false;
                        break;
                    }
//                    if (Card.GetTrackData(CardData) == 0) {
//                        Card.GetCardFromTrack(
//                                GlobalConstants.PosCom.stTrans.MainAcc,
//                                GlobalConstants.PosCom.Track2,
//                                GlobalConstants.PosCom.Track3);
//                        card_no = card_no_dis
//                                + new String(
//                                GlobalConstants.PosCom.stTrans.MainAcc);
//                        cardNumber = new String(
//                                GlobalConstants.PosCom.stTrans.MainAcc);
//                        handler.sendEmptyMessage(0);
//                        sloted_card = false;
//                        break;
//                    }
                } else if (iccardflag) {
                    String trackData =  CommonConvert.bytes2HexString(SerialNo);
                    Log.e("iccardflag.trackData=", trackData);
//                    if(!trackData.isEmpty()) {
//                        resultData = trackData;
//                        sloted_card = false;
//                        break;
//                    }
                    //sloted_card = true;
                    RstBuf = new byte[128];
                    Rlen = new byte[8];
                    ret =JCallback.IccInit_Api(0, 3, RstBuf, Rlen);
                    ret =  JCallback.IccDetect_Api(0);
                    ret = ret == 0 ? JCallback.IccInit_Api(0, 3, RstBuf, Rlen): ret;

                    ret = IcApi.IccInit_Api(0, 3, RstBuf, Rlen);

                    Log.e(TAG, "IccInit_Api= " + ret);
                    if (ret != 0) {
                        return ("IccInit_Api error = " + ret);
                    }
//                    ret = IcApi.IccGetCardType_Api();
//                    Log.e(TAG, "IccGetCardType_Api= " + ret);


                    ApduSend send = new ApduSend();
                    ApduResp recv = new ApduResp();
                    send.Command[0] = (byte) 0x00;
                    send.Command[1] = (byte) 0xa4;
                    send.Command[2] = (byte) 0x04;
                    send.Command[3] = (byte) 0x00;
                    send.Lc = 14;
                    //1PAY.SYS.DDF01
                    byte[] DataIn = new byte[]{(byte)0x0E, 0x00, 0x32, 0x50, 0x41, (byte)0x59, (byte)0x2E, 0x53, (byte)0x59, (byte)0x53, (byte)0x2E, 0x44, 0x44, 0x46, 0x30, 0x31, 0x10, 0x01};
                    System.arraycopy(DataIn, 0, send.DataIn, 0, send.Lc);
                    send.Le = 256;

                    String command = "00A404000E00325041592E5359532E44444630310001";
                    byte[] sendDataIn = CommonConvert.hexStringToByte(command);
                    CardData = new byte[1024];
                    JCallback.IccIsoCommand_Api((byte) 0x00,sendDataIn,CardData);

                    String resultCardData =  CommonConvert.bytes2HexString(CardData);
                    if(!resultCardData.isEmpty()){
                        resultData = resultCardData;
                        sloted_card = false;
                        break;
                    }

//                    send.Le = 256;
//                    IcApi.IccIsoCommand_Api(0, send, recv);
//                    if (recv.readCardDataOk == 1) {
//                        Log.e(TAG, "IccIsoCommand get APDU");
//                        byte[] result = new byte[64];
//                        result[0] = recv.sWA;
//                        result[1] = recv.sWB;
//                        resultData =  ("swa=" + (recv.sWA & 0xff) + ",swb=" + recv.sWB+ ",dataOut=" + CommonConvert.bytes2HexString(recv.dataOut));
//                        Log.e(TAG, "resultData:"+resultData);
//                        sloted_card = false;
//                        break;
//                    }
//                    else {
//                        resultData = ("IccIsoCommand_Api error");
//                    }



//                    card_no = "Processing...";// new
//                    handler.sendEmptyMessage(0);
//                    // ByteUtils.memset(Date, 0, Date.length);
//                    EmvLibApi
//                            .EmvSetIcCardType_Api(CoreDefConstants.PEDICCARD); // Ic��ʽѡ��
//                    TCardAccountInfo pAccInfo = new TCardAccountInfo();
//                    if (EmvCommon.EmvCardProcSL(2, 1, pAccInfo) == 0) {
//                        card_no = card_no_dis
//                                + new String(pAccInfo.MainAcc).trim();
//                        cardNumber = new String(pAccInfo.MainAcc)
//                                .trim();
//                        handler.sendEmptyMessage(0);
//                        sloted_card = false;
//                        //
//                        break;
//                    } else {
//                        card_no = "Read IC failed";// new
//                        handler.sendEmptyMessage(0);
//                        SystemApi.Delay_Api(1000);
//                        continue;
//                    }

                } else if (picccardflag) {
                    Log.e("picccardflag", "check card success");
                    Log.e("picccardflag", "sn：" + CommonConvert.bytes2HexString(SerialNo));
                    String trackData =  CommonConvert.bytes2HexString(SerialNo);
                    //Log.e("picccardflag.trackData=", trackData);
                    if(!trackData.isEmpty()) {
                        String command = "00A404000E00325041592E5359532E44444630310001";
                        String commandSelectAppTV = "00A404000Cf7040000016549442D56535300";

                        String inAuth = "0088008008000000000000000100";

                        byte[] cmdIn = {
                                0x00,
                                (byte)0xA4,
                                0x04,
                                0x00,
                                0x0C,
                                (byte)0xf7,
                                0x04,
                                0x00,
                                0x00,
                                0x01,
                                0x65,
                                0x49,
                                0x44,
                                0x2D,
                                0x56,
                                0x53,
                                0x53,
                                0x00
                        };
                        byte[] cmdResp = new byte[1024];
                        Log.e("picccardflag", "cmdIn = "+ commandSelectAppTV);
                        ret = PiccApi.PiccIsoCommand_Api(CardType[0], cmdIn, cmdIn.length, cmdResp);
                        Log.e("picccardflag", "ret = "+ ret + " cmdRespSelectAppTV = "+CommonConvert.bytes2HexString(cmdResp));
                        //resultData = CommonConvert.bytes2HexString(cmdResp);

                        byte[] cmdIn_inAuth  = {
                                0x00,
                                (byte)0x88,
                                0x00,
                                (byte)0x80,
                                0x08,
                                0x00,
                                0x00,
                                0x00,
                                0x00,
                                0x00,
                                0x00,
                                0x00,
                                0x01,
                                0x00
                        };
                        cmdResp = new byte[1024];
                        ret = PiccApi.PiccIsoCommand_Api(CardType[0], cmdIn_inAuth, cmdIn_inAuth.length, cmdResp);
                        resultData = CommonConvert.bytes2HexString(cmdResp);
                        Log.e("picccardflag", "ret = "+ ret + " cmdRespinAuth = "+CommonConvert.bytes2HexString(cmdResp));
                        if(ret == 0) {
                            ret = PiccApi.PiccClose_Api();
                            sloted_card = false;
                            break;
                        }
                    }
//                    card_no = "Processing...";// new
//                    handler.sendEmptyMessage(0);
//                    EmvLibApi.EmvSetIcCardType_Api(3); // PICC��ʽѡ��
//                    TCardAccountInfo pAccInfo = new TCardAccountInfo();
//                    if (EmvCommon.EmvCardProcSL(2, 1, pAccInfo) == 0) {
//                        card_no = card_no_dis
//                                + new String(pAccInfo.MainAcc).trim();
//                        cardNumber = new String(pAccInfo.MainAcc)
//                                .trim();
//                        handler.sendEmptyMessage(0);
//                        sloted_card = false;
//                        break;
//                    } else {
//                        card_no = "Read CL failed!";// new
//                        handler.sendEmptyMessage(0);
//                        SystemApi.Delay_Api(1000);
//                        continue;
//                    }
                }
            }




//            //寻卡
//            int Ret = PiccApi.PiccCheck_Api(0, CardType, SerialNo);
//            if (Ret == 0) {
//                Log.e("vanstone", "check card success");
//                Log.e("vanstone", "sn：" + CommonConvert.bytes2HexString(SerialNo));
//                break;
//            } else {
//                Log.e("vanstone", "check card fail");
//            }
        }


        return resultData;
    }

    public void PiccIsoTest() {
        byte[] CardType = new byte[2], SerialNo = new byte[20];
        int ret = PiccApi.PiccOpen_Api();
        Log.e("vanstone", "picc open ret = " + ret);
        if (ret != 0) return;
        while (true) {
            //寻卡
            int Ret = PiccApi.PiccCheck_Api(0, CardType, SerialNo);
            if (Ret == 0) {
                Log.e("vanstone", "check card success");
                Log.e("vanstone", "sn：" + CommonConvert.bytes2HexString(SerialNo));
                break;
            } else {
                Log.e("vanstone", "check card fail");
            }
        }

        String command = "00A404000E00325041592E5359532E44444630310001";
        byte[] cmdIn = CommonConvert.hexStringToByte(command);
        byte[] cmdResp = new byte[1024];
        Log.e("vanstone", "cmdIn = "+ command);
        ret = PiccApi.PiccIsoCommand_Api(CardType[0], cmdIn, cmdIn.length, cmdResp);
        Log.e("vanstone", "ret = "+ ret + " cmdResp = "+CommonConvert.bytes2HexString(cmdResp));


        byte[] cmdIn1 = CommonConvert.hexStringToByte("00A404000Cf7040000016549442D56535300");
        byte[] cmdResp1 = new byte[1024];
        Log.e("vanstone", "cmdIn = "+ CommonConvert.bytes2HexString(cmdIn1));
        ret = PiccApi.PiccIsoCommand_Api(CardType[0], cmdIn1, cmdIn1.length, cmdResp1);
        Log.e("vanstone", "ret = "+ ret + " cmdResp1 = "+CommonConvert.bytes2HexString(cmdResp1));


        byte[] cmdInAuth =  { 0x00, (byte)0x88, 0x00, (byte)0x80, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,0x00 };
        byte[] cmdResp2 = new byte[1024];
        Log.e("vanstone", "cmdIn = "+ CommonConvert.bytes2HexString(cmdInAuth));
        ret = PiccApi.PiccIsoCommand_Api(CardType[0], cmdInAuth, cmdInAuth.length, cmdResp2);
        Log.e("vanstone", "ret = "+ ret + " cmdResp2 = "+CommonConvert.bytes2HexString(cmdResp2));

        ret = PiccApi.PiccClose_Api();
        Log.e("vanstone", "picc close ret = "+ret);
    }

}
