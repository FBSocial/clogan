import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_plugin_demo_method_channel.dart';

abstract class FlutterPluginDemoPlatform extends PlatformInterface {
  /// Constructs a FlutterPluginDemoPlatform.
  FlutterPluginDemoPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPluginDemoPlatform _instance = MethodChannelFlutterPluginDemo();

  /// The default instance of [FlutterPluginDemoPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPluginDemo].
  static FlutterPluginDemoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPluginDemoPlatform] when
  /// they register themselves.
  static set instance(FlutterPluginDemoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
