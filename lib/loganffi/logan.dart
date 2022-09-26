import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'allocation.dart';

typedef LoganInitDart = int Function(
    Pointer<Utf8>, Pointer<Utf8>, int, int, Pointer<Utf8>, Pointer<Utf8>);
typedef LoganInit = Int32 Function(
    Pointer<Utf8>, Pointer<Utf8>, Int32, Int32, Pointer<Utf8>, Pointer<Utf8>);

typedef LoganOpenFileDart = int Function(Pointer<Utf8>);
typedef LoganOpenFile = Int32 Function(Pointer<Utf8>);

typedef WriteLogDart = int Function(
    int, Pointer<Utf8>, int, Pointer<Utf8>, int, int);
typedef WriteLog = Int32 Function(
    Int32, Pointer<Utf8>, Int64, Pointer<Utf8>, Int64, Int64);

typedef loganFlushDart = int Function();
typedef loganFlush = Int32 Function();

class Clogan {
  static DynamicLibrary? nativeLogLib;

  static void init(String cacheDir, String pathDir, int maxFile, int max_count,
      String encryptKey, String encryptIv) {

    nativeLogLib = Platform.isAndroid
    ? DynamicLibrary.open("liblogan.so"): DynamicLibrary.process();

    final loganInitPointer =
        nativeLogLib!.lookup<NativeFunction<LoganInit>>('clogan_init');
    final init = loganInitPointer.asFunction<LoganInitDart>();
    int result = init(Utf8.toUtf8(cacheDir), Utf8.toUtf8(pathDir), maxFile,
        max_count, Utf8.toUtf8(encryptKey), Utf8.toUtf8(encryptIv));
    print('init:${result}');
  }

  static void open(String fileName) {
    final openLogan =
        nativeLogLib!.lookup<NativeFunction<LoganOpenFile>>('clogan_open');
    final open = openLogan.asFunction<LoganOpenFileDart>();
    open(Utf8.toUtf8(fileName));
  }

  static void log(int flag, String log) {
    write(flag, log, DateTime.now().millisecondsSinceEpoch, 'main', 1, true);
  }

  static void write(int flag, String log, int time, String threadName,
      int threadId, bool isMainThread) {
    final writeLogan =
        nativeLogLib!.lookup<NativeFunction<WriteLog>>('clogan_write');
    final write = writeLogan.asFunction<WriteLogDart>();
    write(flag, Utf8.toUtf8(log), time, Utf8.toUtf8(threadName), threadId,
        isMainThread ? 0 : 1);
  }

  static void flush() {
    final flushLogan = nativeLogLib!.lookup<NativeFunction<loganFlush>>('clogan_flush');
    final flush = flushLogan.asFunction<loganFlushDart>();
    flush();
  }
}

const int _kMaxSmi64 = (1 << 62) - 1;
const int _kMaxSmi32 = (1 << 30) - 1;
final int _maxSize = sizeOf<IntPtr>() == 8 ? _kMaxSmi64 : _kMaxSmi32;

class Utf8 extends Struct {
  @Int32()
  external int x;

  external Pointer<Utf8> addressOf;

  /// Returns the length of a null-terminated string -- the number of (one-byte)
  /// characters before the first null byte.
  static int strlen(Pointer<Utf8> string) {
    final Pointer<Uint8> array = string.cast<Uint8>();
    final Uint8List nativeString = array.asTypedList(_maxSize);
    return nativeString.indexWhere((char) => char == 0);
  }

  /// Creates a [String] containing the characters UTF-8 encoded in [string].
  ///
  /// The [string] must be a zero-terminated byte sequence of valid UTF-8
  /// encodings of Unicode code points. It may also contain UTF-8 encodings of
  /// unpaired surrogate code points, which is not otherwise valid UTF-8, but
  /// which may be created when encoding a Dart string containing an unpaired
  /// surrogate. See [Utf8Decoder] for details on decoding.
  ///
  /// Returns a Dart string containing the decoded code points.
  static String fromUtf8(Pointer<Utf8> string) {
    final int length = strlen(string);
    return utf8.decode(Uint8List.view(
        string.cast<Uint8>().asTypedList(length).buffer, 0, length));
  }

  /// Convert a [String] to a Utf8-encoded null-terminated C string.
  ///
  /// If 'string' contains NULL bytes, the converted string will be truncated
  /// prematurely. Unpaired surrogate code points in [string] will be preserved
  /// in the UTF-8 encoded result. See [Utf8Encoder] for details on encoding.
  ///
  /// Returns a malloc-allocated pointer to the result.
  static Pointer<Utf8> toUtf8(String string) {
    final units = utf8.encode(string);
    final Pointer<Uint8> result = allocate<Uint8>(count: units.length + 1);
    final Uint8List nativeString = result.asTypedList(units.length + 1);
    nativeString.setAll(0, units);
    nativeString[units.length] = 0;
    return result.cast();
  }

  String toString() => fromUtf8(addressOf);
}
