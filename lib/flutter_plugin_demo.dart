
import 'flutter_plugin_demo_platform_interface.dart';

class FlutterPluginDemo {
  Future<String?> getPlatformVersion() {
    return FlutterPluginDemoPlatform.instance.getPlatformVersion();
  }
}
