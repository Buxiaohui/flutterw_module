import 'dart:ui';

class SizeUtils {
  static double getDevicesHeightPx() {
    Size x = window.physicalSize;
    return x.height;
  }

  static double getDevicesWidthPx() {
    Size x = window.physicalSize;
    print("getDevicesWidthPx,$x.width");
    double xx = (x.width / 2.0);
    print("getDevicesWidthPx,$xx");
    return x.width;
  }

  /// android:DP
  /// ios:pt
  /// TODO
  static double getDevicesHeight() {
    Size x = window.physicalSize;
    return x.height;
  }
  /// android:DP
  /// ios:pt
  /// TODO
  static double getDevicesWidth() {
    Size x = window.physicalSize;
    print("getDevicesWidthPx,$x.width");
    double xx = (x.width / 2.0);
    print("getDevicesWidthPx,$xx");
    return x.width;
  }
}
