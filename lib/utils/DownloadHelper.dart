import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterw_module/utils/Md5Helper.dart';
import 'package:flutterw_module/utils/PathHelper.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadHelper {
  static void download(String url, String path, Function callback,
      {OnDownloadProgress onDownloadProgress}) async {
    Dio dio = new Dio();
    Response response =
        await dio.download(url, path, onProgress: onDownloadProgress);
    if (response != null) {
      print(response.data.hashCode);
    } else {
      print("response is null");
    }
    if (callback != null) {
      callback(url, path, response);
    }
  }

  static Future<bool> onImageLongPressed(BuildContext ctx, String url) async {
    return showDialog(
          context: ctx,
          builder: (context) => new AlertDialog(
            title: new Text('Download'),
            content: new Text('下载图片到本地'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  downloadImage(url);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    print(permissionRequestResult);
    PermissionStatus permissionStatus = permissionRequestResult[permission];
    print("requestPermission:" + permissionStatus.toString());
  }

  static checkPermission(PermissionGroup permission) async {
    ServiceStatus ret =
        await PermissionHandler().checkServiceStatus(permission);
    print("permission is " + ret.toString());
  }

  static void downloadImage(String url) async {
    ServiceStatus ret = await checkPermission(PermissionGroup.storage);
    bool resCheck = ret == ServiceStatus.enabled;
    if (resCheck) {
      realDownload(url);
    } else {
      ServiceStatus permissionStatus =
          await requestPermission(PermissionGroup.storage);
      if (ServiceStatus.enabled == permissionStatus) {
        realDownload(url);
      }
    }
  }

  void checkServiceStatus(BuildContext context, PermissionGroup permission) {
    PermissionHandler()
        .checkServiceStatus(permission)
        .then((ServiceStatus serviceStatus) {
      final SnackBar snackBar =
          SnackBar(content: Text(serviceStatus.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void checkPermissionStatus(BuildContext context, PermissionGroup permission) {
    PermissionHandler()
        .checkServiceStatus(permission)
        .then((ServiceStatus serviceStatus) {});
  }

  static void realDownload(String url) async {
    String path = await PathHelper.getExternalStorageDir();
    List<String> strs = url.split(".");
    path =
        path + "/" + Md5Helper.generateMd5(url) + "." + strs[strs.length - 1];
    DownloadHelper.download(url, path,
        (String url, String path, Response response) {
      print("downloadImage $url ...  $path");
      if (response != null) {
        print("downloadImage $response.data");
      }
    }, onDownloadProgress: (int received, int total) {
      double d = (received / total) * 100;
      String dp = d.toString() + "%";
      print("downloadImage $total ...  $received ... $dp");
    });
  }
}
