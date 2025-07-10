import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' show Platform;

class ScaledSizeUtil {
  /// Default size for device
  static const Size defaultSize = Size(360, 640);

  /// [Size] of the device
  static late Size _ui;

  /// Boolean to indicate text scaling
  static late bool _allowTextScaling = true;

  /// Screen width of the device
  static late double _screenWidth;

  /// Screen height of the device
  static late double _screenHeight;

  /// Base size used to calculate rem [ScaledSizeUtil.rem]
  static late double _base;

  /// Current Orientation of the device
  static late Orientation _orientation;

  /// [ScaledSizeUtil.deviceType]
  static late DeviceType _deviceType;

  ScaledSizeUtil._();

  /// Initializing [ScaledSizeUtil]
  static void init(
    BoxConstraints constraints,
    Orientation orientation, {
    double base = 16.0,
    Size size = defaultSize,
    bool allowTextScaling = true,
  }) {
    _orientation = orientation;
    _ui = size;
    _allowTextScaling = allowTextScaling;

    /// Sets the device _screenWidth and _screenHeight
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    /// Sets the device type
    if (kIsWeb) {
      _deviceType = DeviceType.Web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      /// Based on the device's orientation and size _deviceType will be assigned
      if ((_orientation == Orientation.portrait && _screenWidth < 600) ||
          (_orientation == Orientation.landscape && _screenHeight < 600)) {
        _deviceType = DeviceType.Mobile;
      } else {
        _deviceType = DeviceType.Tablet;
      }
    } else if (Platform.isMacOS) {
      _deviceType = DeviceType.Mac;
    } else if (Platform.isWindows) {
      _deviceType = DeviceType.Windows;
    } else if (Platform.isLinux) {
      _deviceType = DeviceType.Linux;
    } else if (Platform.isFuchsia) {
      _deviceType = DeviceType.Fuchsia;
    }

    _base = base;
  }

  /// Gives the screen width of the device
  static double get screenWidth => _screenWidth;

  /// Gives the screen height of the device
  static double get screenHeight => _screenHeight;

  /// Gives the scale width for the device
  static double get scaleW => _screenWidth / _ui.width;

  /// Gives the scale height for the device
  static double get scaleH => _screenHeight / _ui.height;

  /// Gives the scale factor for the device
  static double get scale => max(scaleW, scaleH);

  /// Returns text scaling factor which will be later used for font size in [ScaledSizeUtil.scaledFontSize]
  static double get textScaleFactor =>
      WidgetsBinding.instance!.window.textScaleFactor;

  /// Gives the responsive height
  static double height(num input) => input * scaleH;

  /// Gives the responsive width
  static double width(num input) => input * scaleW;

  /// caculates the view height for the given input
  static double viewHeight(num input) => input * (_screenHeight / 100);

  /// calculates the view width for the given input
  static double viewWidth(num input) => input * (_screenWidth / 100);

  /// Returns font size in rem based on the input and base size
  static double rem(num input) => input * _base * textScaleFactor;

  /// Gives the font size in scalarPixels based on the input
  /// If [_allowTextScaling] is set true it will returns a scalable font size
  /// If [_allowTextScaling] is set false it will returns a non scalable font size
  static double scaledFontSize(num input) =>
      _allowTextScaling ? input * scale * textScaleFactor : input * scale;

  /// Return the radius for rounded corners
  static double radius(num input) => input * scale;

  /// Gives the current orientation of the device
  static Orientation get orientation => _orientation;

  /// Gives the current device type [ScaledSizeUtil.deviceType]
  static DeviceType get deviceType => _deviceType;

  /// Return maximum value between [ScaledSizeUtil.viewWidth] and [ScaledSizeUtil.viewHeight]
  static double maxViewPort(num input) {
    double vH = viewHeight(input);
    double vW = viewWidth(input);
    return max(vH, vW);
  }
}

/// Enum to store device type
enum DeviceType {
  Mobile,
  Tablet,
  Web,
  Mac,
  Windows,
  Linux,
  Fuchsia,
}
