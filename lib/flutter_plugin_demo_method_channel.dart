import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_plugin_demo_platform_interface.dart';

/// An implementation of [FlutterPluginDemoPlatform] that uses method channels.
class MethodChannelFlutterPluginDemo extends FlutterPluginDemoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_plugin_demo');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
