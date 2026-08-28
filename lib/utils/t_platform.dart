// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'dart:ui';

import 'package:flutter/foundation.dart';

enum TDeviceType { mobile, tablet, desktop }

/// Web-Safe operating system checking, and device type from the screen/view size.
///
/// If you want more information about the current device, I recommend the
/// [device_info_plus](https://pub.dev/packages/device_info_plus) package.
final class TPlatform {
  /// If the current platform is a web browser
  static bool get isWeb => kIsWeb;

  /// If the current operating system is Android (non web browser).
  static bool get isAndroid => !isWeb && defaultTargetPlatform == TargetPlatform.android;

  /// If the current operating system is iOS (non web browser).
  static bool get isIOS => !isWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// If the current operating system is macOS (non web browser).
  static bool get isMacOS => !isWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// If the current operating system is a Linux distro (non web browser).
  static bool get isLinux => !isWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// If the current operating system is Windows (non web browser).
  static bool get isWindows => !isWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// If the current operating system is Fuchsia OS (non web browser).
  static bool get isFuchsia => !isWeb && defaultTargetPlatform == TargetPlatform.fuchsia;

  /// If the current platform is an Apple one.
  static bool get isApple => isIOS || isMacOS;

  /// If the current platform is a Google one.
  static bool get isGoogle => isAndroid || isFuchsia;

  /// If the current device is a Mobile Phone.
  static bool get isMobile => getDeviceType() == TDeviceType.mobile;

  /// If the current device is a Desktop.
  static bool get isDesktop => getDeviceType() == TDeviceType.desktop;

  /// If the current device is a Tablet.
  static bool get isTablet => getDeviceType() == TDeviceType.tablet;

  /// Returns the device type from the screen/view size.
  ///
  /// If you want more information about the current device, I recommend the
  /// [device_info_plus](https://pub.dev/packages/device_info_plus) package.
  static TDeviceType getDeviceType() {
    final FlutterView view = PlatformDispatcher.instance.implicitView ?? PlatformDispatcher.instance.views.first;

    // Calculate physical display width in logical pixels
    final double physicalWidth = view.physicalSize.width;
    final double devicePixelRatio = view.devicePixelRatio;
    final double logicalWidth = physicalWidth / devicePixelRatio;

    final isDesktopPlatform =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);

    if (isDesktopPlatform) {
      return TDeviceType.desktop;
    }

    if (logicalWidth >= 600) {
      return TDeviceType.tablet;
    }

    return TDeviceType.mobile;
  }
}
