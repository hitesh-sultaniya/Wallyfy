package com.lemontreeapps.wallyfy;

import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "wallyfy.lemotreeapps.com/wallpaper";
    private DownloadManager downloadManager;
    private Uri Download_Uri;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        downloadManager = (DownloadManager) getSystemService(this.DOWNLOAD_SERVICE);
        registerReceiver(onComplete,
                new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("downloadWallPaper")) {
                            final String getImgUrl = call.arguments();
                            downloadWallPaper(getImgUrl);
                            result.success(true);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    private void downloadWallPaper(String imgUrl) {

        Download_Uri = Uri.parse(imgUrl);

        DownloadManager.Request request = new DownloadManager.Request(Download_Uri);
        request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI | DownloadManager.Request.NETWORK_MOBILE);
        request.setAllowedOverRoaming(false);
        request.setTitle("Wallyfy Downloading " + "WallyfyWallaper" + ".jpg");
        request.setDescription("Downloading " + "WallyfyWallaper" + ".jpg");
        request.setVisibleInDownloadsUi(true);
        request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, "/Wallyfy/"  + "/" + "WallyfyWallaper" + ".png");

        downloadManager.enqueue(request);

    }

    BroadcastReceiver onComplete = new BroadcastReceiver() {

        public void onReceive(Context ctxt, Intent intent) {
            Toast toast=Toast.makeText(getApplicationContext(),"WallPaper Download Successfully",Toast.LENGTH_SHORT);
            toast.show();
        }
    };
}
