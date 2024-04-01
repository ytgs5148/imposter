import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class UniqueID {
  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;

      return iosDeviceInfo.identifierForVendor ?? 'n/a';
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.id;
    }
    return 'n/a';
  }
}