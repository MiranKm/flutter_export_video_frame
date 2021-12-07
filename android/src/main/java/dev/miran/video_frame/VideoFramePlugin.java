package dev.miran.video_frame;

import android.app.Activity;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PointF;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** VideoFramePlugin */
public class VideoFramePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  private static final String TAG = "VideoFramePlugin";
  private MethodChannel channel;
  private Activity activity;
  private  PermissionManager permissionManager = new PermissionManager();
  private  FlutterPluginBinding flutterPluginBinding;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "video_frame");
    this.flutterPluginBinding = flutterPluginBinding;
    FileStorage.share().setContext(flutterPluginBinding.getApplicationContext());
    AblumSaver.share().setCurrent(flutterPluginBinding.getApplicationContext());
    VideoFramePlugin plugin = new VideoFramePlugin();
    channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

   /* if (!permissionManager.isPermissionGranted()) {
      permissionManager.askForPermission();
    }
    if (!(FileStorage.isExternalStorageReadable() && FileStorage.isExternalStorageWritable())) {
      result.error("File permission exception","Not get external storage permission",null);
      return;
    }
*/
    switch (call.method) {
      case "getPlatformVersion":{
        result.success("Android " + android.os.Build.VERSION.RELEASE);
      }
      case "cleanImageCache": {
        Boolean success = FileStorage.share().cleanCache();
        if (success) {
          result.success("success");
        } else {
          result.error("Clean exception", "Fail", null);
        }
        break;
      }
      case "saveImage": {
        String filePath = call.argument("filePath").toString();
        String albumName = call.argument("albumName").toString();
        Bitmap waterBitMap = null;
        PointF waterPoint = null;
        Double scale = 1.0;
        AblumSaver.share().setAlbumName(albumName);
        if (call.argument("waterMark") != null && call.argument("alignment") != null) {
          String waterPathKey = call.argument("waterMark").toString();
          AssetManager assetManager = flutterPluginBinding.getApplicationContext().getAssets();
          String key = flutterPluginBinding.getFlutterAssets().getAssetFilePathByName(waterPathKey);
          Map<String,Number> rect = call.argument("alignment");
          Double x = rect.get("x").doubleValue();
          Double y = rect.get("y").doubleValue();
          waterPoint = new PointF(x.floatValue(),y.floatValue());
          Number number = call.argument("scale");
          scale = number.doubleValue();
          try {
            InputStream in = assetManager.open(key);
            waterBitMap = BitmapFactory.decodeStream(in);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        AblumSaver.share().saveToAlbum(filePath,waterBitMap,waterPoint,scale.floatValue(),result);
        break;
      }
      case "exportGifImagePathList": {
        String filePath = call.argument("filePath").toString();
        Number quality = call.argument("quality");
        ExportImageTask task = new ExportImageTask();
        task.execute(filePath,quality);
        task.setCallBack(new Callback() {
          @Override
          public void exportPath(ArrayList<String> list) {
            if (list != null) {
              result.success(list);
            } else {
              result.error("Media exception","Get frame fail", null);
            }
          }
        });
        break;
      }
      case "exportImage": {
        String filePath = call.argument("filePath").toString();
        Number number = call.argument("number");
        Number quality = call.argument("quality");

        Log.d(TAG, "onMethodCall: "+"path: "+filePath+ " number:"+number.toString()+" quality: "+quality.intValue());
        ExportImageTask task = new ExportImageTask();
        assert number != null;
        task.execute(filePath,number.intValue(),quality);
        task.setCallBack(new Callback() {
          @Override
          public void exportPath(ArrayList<String> list) {
            if (list != null) {
              result.success(list);
            } else {
              result.error("Media exception","Get frame fail", null);
            }
          }
        });
        break;
      }
      case "exportImageBySeconds": {
        String filePath = call.argument("filePath").toString();
        Number duration = call.argument("duration");
        Number radian = call.argument("radian");
        ExportImageTask task = new ExportImageTask();
        task.execute(filePath,duration.longValue(),radian);
        task.setCallBack(new Callback() {
          @Override
          public void exportPath(ArrayList<String> list) {
            if ((list != null) && (list.size() > 0)) {
              result.success(list.get(0));
            } else {
              result.error("Media exception","Get frame fail", null);
            }
          }
        });
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }



  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    this.activity = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    permissionManager.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();

  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }
}
