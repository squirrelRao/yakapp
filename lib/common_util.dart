class LogUtil {

  static bool debuggable = false; //是否是debug模式,true: log v 不输出.
  static String TAG = "[YAK]";

  static void init(bool isDebug) {
    debuggable = isDebug;
  }

  static void e(Object object) {
    _printLog('-error-', object);
  }

  static void i(Object object) {
    if (debuggable) {
      _printLog('-info-', object);
    }
  }

  static void _printLog(String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write(TAG);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}

