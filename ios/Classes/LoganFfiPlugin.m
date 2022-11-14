#import "LoganFfiPlugin.h"

#import <clogan_core.h>

@implementation LoganFfiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_demo"
            binaryMessenger:[registrar messenger]];
  LoganFfiPlugin* instance = [[LoganFfiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// 构造空方法，为了让编译器在release 的时候，不能去掉 libclogan.a的引用
-(void)toUseLibClogan:(int)debug {
        clogan_init("a", "a", 1, 0, "A", "A");
        clogan_open(nil);
        clogan_write(0, "a", 0, 0, 0, 0);
        clogan_debug(0);
        clogan_flush();
}
@end
