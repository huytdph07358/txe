package com.vietsens.txe.txe_pos_integrate;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.RemoteException;
import android.util.Base64;
import android.util.Log;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;

import com.atom.atom_pos.payment.AtomPos;
import com.sunmi.peripheral.printer.InnerResultCallback;

import com.vanstone.trans.api.PiccApi;
import com.vanstone.trans.api.PrinterApi;
import com.vanstone.trans.api.SystemApi;
import com.vanstone.utils.CommonConvert;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/** TxePosIntegratePlugin */
public class TxePosIntegratePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private FragmentActivity activity;
  private Activity activityRaw;
  private AtomPos atomPos;
  int printOption = 0;

//  static {
//    System.loadLibrary("A90JavahCore");
//  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "txe_pos_integrate");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("payment")) {
      Log.d("payment", "start");
      paymentListening(call, result);
    } else if (call.method.equals("print")) {
      Log.d("print", "start");
      printListening(call, result);
    }
    else if (call.method.equals("init")) {
      Log.d("init", "start");
      init(call, result);
    }
    else if (call.method.equals("logon")) {
      Log.d("logon", "start");
      logon(call, result);
    }
    else if (call.method.equals("readCard")) {
      Log.d("readCardProcess", "start");
      readCardProcess(call, result);
    }
    else if (call.method.equals("readSam")) {
      Log.d("readSamProcess", "start");
      readSamProcess(call, result);
    }
    else {
      result.notImplemented();
    }
  }

  void logon(MethodCall call, MethodChannel.Result result) {
    if(atomPos==null){
      Log.d("logon: input","atomPos =null");
      return;
    }
    atomPos.executeLogon((resultData) ->{
      Log.d("logon: result", resultData);
      return null;
    });
    result.success(null);
  }

  void init(MethodCall call, MethodChannel.Result result) {
    Map<String, Object> argument = call.arguments();
    //printOption = Integer.parseInt(argument.containsKey("printOption") ? argument.get("printOption").toString() : "0");
    try {
      initSunmiPos(call, result);
      initAtomPrintService(call, result);
      result.success(true);
    } catch (Exception e) {
      result.success(false);
      e.printStackTrace();
    }
  }

  void initSunmiPos(MethodCall call, MethodChannel.Result result) {
    try{
      Log.d("initSunmiPos","1");
      Map<String, Object> argument = call.arguments();
      String deviceInfo = argument.containsKey("deviceInfo") ? argument.get("deviceInfo").toString() : "";
      if(deviceInfo != "" && !deviceInfo.contains("Aisino")) {
        Log.d("initSunmiPos","init.begin");
        SunmiPrintHelper.getInstance().initSunmiPrinterService(context);
        Log.d("initSunmiPos","init.end");
      }
      Log.d("initSunmiPos","2");
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  void initAtomPos(MethodCall call, MethodChannel.Result result) {
    Log.d("initAtomPos","1");
    if(activity==null){
      Log.d("init: input","activity =null");
    }
    Log.d("initAtomPos","2");
    if(atomPos==null){
      Log.d("init: input","atomPos =null");
      return;
    }
    Log.d("initAtomPos","3");
    atomPos.executeInitializes((resultData) ->{
      Log.d("init: result", resultData);
      return null;
    });
    Log.d("initAtomPos","4");
    result.success(null);
  }

  void initAtomPrintService(MethodCall call, MethodChannel.Result result) {
    try{
      Log.d("initAtomPrintService","1");
      Map<String, Object> argument = call.arguments();
      String deviceInfo = argument.containsKey("deviceInfo") ? argument.get("deviceInfo").toString() : "";
      if(deviceInfo.contains("Aisino")){
        Log.d("initAtomPrintService","init.begin");
        String CurDir = context.getFilesDir().getAbsolutePath();
        SystemApi.SystemInit_Api(0, CommonConvert.StringToBytes(CurDir + "/" + "\0"), activity);
        Log.d("initAtomPrintService","init.end");
      }
      Log.d("initAtomPrintService","2");
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  void paymentListening(MethodCall call, MethodChannel.Result result) {
//    if(atomPos==null){
//      Log.d("paymentListening: input","atomPos =null");
//      return;
//    }
//          Log.d("initAtomPos","init.begin");
//      initAtomPos(call, result);
//      Log.d("initAtomPos","init.end");
    if(atomPos==null){
      Log.d("init: input","atomPos =null");
      return;
    }
    Log.d("initAtomPos","3");
//    atomPos.executeInitializes((resultData) ->{
//      Log.d("init: result", resultData);
//      return null;
//    });


    Map<String, Object> argument = call.arguments();
    int listenerId = Integer.parseInt(argument.containsKey("listenerId") ? argument.get("listenerId").toString() : "0");
    double amount = Double.parseDouble(argument.containsKey("amount") ? argument.get("amount").toString() : "0");
    String extraData = argument.containsKey("extraData") ? argument.get("extraData").toString() : "";
    Log.d("listenerId", listenerId + "");
    try {
      JSONObject jsonObject = new JSONObject();
      jsonObject.put(AtomPos.KEY_TYPE, AtomPos.PaymentTypes.NORMAL);
      jsonObject.put(AtomPos.KEY_DATA, amount);
      jsonObject.put(AtomPos.EXTRA_DATA, extraData);
      Log.d("payment",  "processing...");
      atomPos.executePayment(jsonObject.toString(), (String resultData) ->{
        Log.d("payment",  "success, resultData=" + resultData);
        Map<String, Object> args = new HashMap();
        args.put("id", listenerId);
        args.put("success", true);
        args.put("resultData", resultData);
        // Send some value to callback
        channel.invokeMethod("callBackListener", args);
        return null;
      });

      result.success(null);
    } catch (Exception e) {
      result.success(false);
      e.printStackTrace();
    }
  }

  void printListening(MethodCall call, MethodChannel.Result result) {

    Map<String, Object> argument = call.arguments();
    printOption = Integer.parseInt(argument.containsKey("printOption") ? argument.get("printOption").toString() : "0");
    try {

      if(SunmiPrintHelper.getInstance().CheckSunmiPrinterAvaiable()) {
        Log.d("printOption",  "printWithSunmiService");
        printWithSunmiService(call, result);
      }
      else{
        Log.d("printOption",  "printWithAtomService");
        printWithAtomService(call, result);
      }

      result.success(null);
    } catch (Exception e) {
      result.success(false);
      e.printStackTrace();
    }
  }

  void printWithSunmiService(MethodCall call, MethodChannel.Result result){
    try {
      Map<String, Object> argument = call.arguments();
      int listenerId = Integer.parseInt(argument.containsKey("listenerId") ? argument.get("listenerId").toString() : "0");
      String qrCode = argument.containsKey("qrCode") ? argument.get("qrCode").toString() : "";
      if(SunmiPrintHelper.getInstance().CheckSunmiPrinterAvaiable()) {
//      String price = String.valueOf(argument.containsKey(argument.containsKey("price") ? argument.get("price").toString() : ""));
      String price = argument.containsKey("price") ? argument.get("price").toString() : "";
      String exportTime = argument.containsKey("exportTime") ? argument.get("exportTime").toString() : "";
      String serialNumber = argument.containsKey("serialNumber") ? argument.get("serialNumber").toString().toUpperCase() : "";
      String licensePlate = argument.containsKey("licensePlate") ? argument.get("licensePlate").toString() : "";
      String lineName = argument.containsKey("lineName") ? argument.get("lineName").toString().toUpperCase() : "";
      String seatCode = argument.containsKey("seatCode") ? argument.get("seatCode").toString().toUpperCase() : "";
      String exportHour = argument.containsKey("exportHour") ? argument.get("exportHour").toString() : "";

        SunmiPrintHelper.getInstance().ProcessEnterPrinterBuffer();
        //SunmiPrintHelper.getInstance().printText(tenTuyen + "\n", 20, true);
//        // SunmiPrintHelper.getInstance().printImagefromBase64(image + "                   " + "\n");
//        SunmiPrintHelper.getInstance().printImagefromBase64test(image);
//        SunmiPrintHelper.getInstance().printTextAlignRight( " " + SoLoaiVe + "\n", 75, true);
//        SunmiPrintHelper.getInstance().printTextAlignCenter("TRUNG TÂM QUẢN LÝ GIAO THÔNG CÔNG CỘNG\nTHÀNH PHỐ HÀ NỘI" + "\n", 18, true);
//        SunmiPrintHelper.getInstance().printTextAlignCenter( "Địa chỉ: Số 1 Kim Mã - Ba Đình - HN" + "\n", 18, true);
//        SunmiPrintHelper.getInstance().printTextAlignCenter( "Mã số thuế: 0100778682" + "\n \n", 18, true);
        SunmiPrintHelper.getInstance().printQr(qrCode , 6, 1);
//        SunmiPrintHelper.getInstance().printText("VÉ THAM QUAN"+"\n" , 35, true);
        SunmiPrintHelper.getInstance().printTextAlignCenter("" + "\n", 10, true);
        SunmiPrintHelper.getInstance().printText("VÉ TÀU" + "\n", 65, true, false, "");
        SunmiPrintHelper.getInstance().printTextAlignCenter("(Xin giữ vé để kiểm soát)" + "\n", 18, true);
//        SunmiPrintHelper.getInstance().printTextAlignLeft("GIÁ VÉ:", 22, true);
        SunmiPrintHelper.getInstance().printTextAlignCenter("Giá vé: " + price + " đồng" + "\n", 27, true);
        SunmiPrintHelper.getInstance().printTextAlignCenter("(Vé có bảo hiểm)" + "\n", 18, true);
        SunmiPrintHelper.getInstance().printTextAlignRight("Số ghế: ", 18, true);
        SunmiPrintHelper.getInstance().printTextAlignLeft(seatCode + "\n", 23, true);
        SunmiPrintHelper.getInstance().printTextAlignRight("Chuyến:" , 18, true);
        SunmiPrintHelper.getInstance().printTextAlignLeft(lineName + "\n", 25, true );
        SunmiPrintHelper.getInstance().printTextAlignLeft("Ngày:" + exportTime + "              Giờ:" + exportHour +"\n", 18, true);
//        SunmiPrintHelper.getInstance().printTextAlignLeft("Giờ:" + exportTime +"\n", 22, true);
//        SunmiPrintHelper.getInstance().printTextAlignLeft("HOTLINE:1900 6888" + "       " + "Lần in:" + PrintCount + "\n", 22, true);
//        SunmiPrintHelper.getInstance().printText("Vui lòng giữ vé trong quá trình sử dụng"+ "  " + "\n", 18, true);
//        SunmiPrintHelper.getInstance().printText("Tra cứu biên lai điện tử tại"+ "  "+ "\n", 18, true);
//        SunmiPrintHelper.getInstance().printText("https://tracuuhoadon.1ve.vn"+ "  "+ "\n", 18, true);
        SunmiPrintHelper.getInstance().feedPaper();


        InnerResultCallback mCallback = new InnerResultCallback() {
          @Override
          public void onRunResult(boolean isSuccess) {
            Log.d("onRunResult.isSuccess", isSuccess + "");
          }

          @Override
          public void onReturnString(String result) {
            Log.d("onReturnString.result", result + "");
          }

          @Override
          public void onRaiseException(int code, String msg) {
            Log.d("onRaiseException____", "code:"+code + ", msg:"+msg);
            Map<String, Object> args = new HashMap();
            args.put("id", listenerId);
            args.put("success", false);
            args.put("result", "code:"+code + ", msg:"+msg);
            // Send some value to callback
            channel.invokeMethod("callBackListener", args);
          }

          @Override
          public void onPrintResult(int code, String msg) {
            final int res = code;
            Log.d("onPrintResult____", "code:"+code + ", msg:"+msg);
            Map<String, Object> args = new HashMap();
            args.put("id", listenerId);
            args.put("success", true);
            args.put("result", "code:"+code + ", msg:"+msg);
            channel.invokeMethod("callBackListener", args);
          }
        };

        SunmiPrintHelper.getInstance().ProcessCommitPrinterBuffer(mCallback);
        SunmiPrintHelper.getInstance().feedPaper();
      }
      else{
        //successCallback.invoke(false, "no found printer");
        Map<String, Object> args = new HashMap();
        args.put("id", listenerId);
        args.put("success", false);
        args.put("result", "no found printer");
        channel.invokeMethod("callBackListener", args);
        Log.d("printWithSunmiService false",  "no found printer");
      }
    }catch (Exception e) {
      e.printStackTrace();
    }

  }

  void printWithAtomService(MethodCall call, MethodChannel.Result result){
    try {
      Map<String, Object> argument = call.arguments();
      int listenerId = Integer.parseInt(argument.containsKey("listenerId") ? argument.get("listenerId").toString() : "0");
      String qrCode = argument.containsKey("qrCode") ? argument.get("qrCode").toString() : "";
      String price = argument.containsKey("price") ? argument.get("price").toString() : "";
      String exportTime = argument.containsKey("exportTime") ? argument.get("exportTime").toString() : "";
      String serialNumber = argument.containsKey("serialNumber") ? argument.get("serialNumber").toString().toUpperCase() : "";
      String licensePlate = argument.containsKey("licensePlate") ? argument.get("licensePlate").toString() : "";
      String lineName = argument.containsKey("lineName") ? argument.get("lineName").toString().toUpperCase() : "";
      String exportHour = argument.containsKey("exportHour") ? argument.get("exportHour").toString() : "";

      PrinterApi.PrnClrBuff_Api();
      PrinterApi.SetLang_Api(PrinterApi.LANG_PERSIAN, PrinterApi.ENCODING_UTF8);
      PrinterApi.PrnFontSet_Api(24, 24, 0);
      PrinterApi.PrnSetGray_Api(15);
      PrinterApi.PrnLineSpaceSet_Api((short) 5, 0);
      PrinterApi.printSetAlign_Api(1);
      PrinterApi.printSetTextSize_Api(18);
      PrinterApi.PrnStr_Api("TRUNG TÂM QUẢN LÝ GIAO THÔNG CÔNG CỘNG");
      PrinterApi.PrnStr_Api("THÀNH PHỐ HÀ NỘI");
      PrinterApi.printSetTextSize_Api(20);
      PrinterApi.PrnStr_Api("Địa chỉ: Số 1 Kim Mã - Ba Đình - HN");
      PrinterApi.PrnStr_Api("Mã số thuế: 0100778682");
      PrinterApi.printAddQrCode_Api(1,250, qrCode);
      PrinterApi.printSetTextSize_Api(55);
      PrinterApi.printSetBlodText_Api(true);
      PrinterApi.PrnStr_Api("VÉ XE BUÝT");
      PrinterApi.printSetBlodText_Api(false);
      PrinterApi.printSetTextSize_Api(14);
      PrinterApi.PrnStr_Api("(Xin giữ vé để kiểm soát)");
//      PrinterApi.PrnFontSet_Api(32, 18, 0);
      //PrinterApi.PrnHTSet_Api(1);
      PrinterApi.printSetTextSize_Api(20);
      PrinterApi.printSetBlodText_Api(true);
      PrinterApi.PrnStr_Api("Giá vé: " + price + " đồng/lượt" );
      PrinterApi.printSetBlodText_Api(false);
      PrinterApi.printSetTextSize_Api(14);
      PrinterApi.PrnStr_Api("(Vé có bảo hiểm)");
      PrinterApi.printSetAlign_Api(0);
      PrinterApi.printSetTextSize_Api(20);
      PrinterApi.PrnStr_Api("Số: "+ serialNumber);
      PrinterApi.PrnStr_Api("Tuyến: "+ lineName+ "       BKS: " + licensePlate);
      PrinterApi.PrnHTSet_Api(0);
      PrinterApi.PrnStr_Api("Ngày: " + exportTime + "       Giờ: " + exportHour);

      for(int i = 0 ; i < 2; i++) {
        PrinterApi.PrnStr_Api("\n");
      }
      printData();
      Map<String, Object> args = new HashMap();
      args.put("id", listenerId);
      args.put("success", true);
      args.put("resultData", args);
      // Send some value to callback
      channel.invokeMethod("callBackListener", args);
      result.success(true);
    }catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void printData() {
    int ret = PrinterApi.PrnStart_Api();
    String Buf;
    if (ret == 2) {
      Buf = "Return：" + ret + "\tpaper is not enough";
    } else if (ret == 3) {
      Buf = "Return：" + ret + "\ttoo hot";
    } else if (ret == 4) {
      Buf = "Return：" + ret + "\tPLS put it back\nPress any key to reprint";
    } else if (ret == 0) {
      PrinterApi.PrnClrBuff_Api();
      return;
    }
    PrinterApi.PrnClrBuff_Api();
  }

  private void readCardProcess (MethodCall call, MethodChannel.Result result){
    Map<String, Object> argument = call.arguments();
    int listenerId = Integer.parseInt(argument.containsKey("listenerId") ? argument.get("listenerId").toString() : "0");
    PicIsoProcessor picIsoProcessor = new PicIsoProcessor();
    //String cardData = picIsoProcessor.piccIso();
    String cardData = "";
    picIsoProcessor.PiccIsoTest();


    Map<String, Object> args = new HashMap();
    args.put("id", listenerId);
    args.put("success", true);
    args.put("resultData", cardData);
    // Send some value to callback
    channel.invokeMethod("callBackListener", args);
    result.success(true);
  }

  private void readSamProcess (MethodCall call, MethodChannel.Result result){
    Map<String, Object> argument = call.arguments();
    int listenerId = Integer.parseInt(argument.containsKey("listenerId") ? argument.get("listenerId").toString() : "0");
    IcCardIsoProcessor icCardIsoProcessor = new IcCardIsoProcessor();
    String samData = icCardIsoProcessor.ExecuteCommand(0);
    Map<String, Object> args = new HashMap();
    args.put("id", listenerId);
    args.put("success", true);
    args.put("resultData", samData);
    // Send some value to callback
    channel.invokeMethod("callBackListener", args);
    result.success(true);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = ((FragmentActivity) binding.getActivity());
    activityRaw = binding.getActivity();
    Log.d("initAtomPos","1");
    atomPos = new AtomPos(activity);
    Log.d("initAtomPos","2");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}

