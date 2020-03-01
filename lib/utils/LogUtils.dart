class LogUtils {
  static const bool enable = true;

  static void log(var tag, var input) {
    if (enable) {
      print(tag.toString() + "-:-" + input.toString());
    }
  }
}
