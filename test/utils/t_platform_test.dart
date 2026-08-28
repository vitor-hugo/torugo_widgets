import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twidgets/twidgets.dart';

void main() {
  group('TPlatform', () {
    testWidgets(
      'Should return desktop where the target platform is a desktop platform',
      (tester) async {
        try {
          for (final platform in [
            TargetPlatform.macOS,
            TargetPlatform.windows,
            TargetPlatform.linux,
          ]) {
            debugDefaultTargetPlatformOverride = platform;

            expect(TPlatform.getDeviceType(), TDeviceType.desktop);
            expect(TPlatform.isDesktop, isTrue);
          }
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    testWidgets(
      'Should classify the current screen where the target platform is not desktop',
      (tester) async {
        try {
          debugDefaultTargetPlatformOverride = TargetPlatform.android;
          final view = PlatformDispatcher.instance.implicitView ?? PlatformDispatcher.instance.views.first;
          final expectedType = view.physicalSize.width / view.devicePixelRatio >= 600
              ? TDeviceType.tablet
              : TDeviceType.mobile;

          expect(TPlatform.getDeviceType(), expectedType);
          expect(TPlatform.isTablet, expectedType == TDeviceType.tablet);
          expect(TPlatform.isMobile, expectedType == TDeviceType.mobile);
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );

    test('Should identify Google platforms where the target platform is Android or Fuchsia', () {
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      for (final platform in [TargetPlatform.android, TargetPlatform.fuchsia]) {
        debugDefaultTargetPlatformOverride = platform;

        expect(TPlatform.isGoogle, isTrue);
        expect(TPlatform.isApple, isFalse);
      }
    });

    test('Should identify Apple platforms where the target platform is iOS or macOS', () {
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
        debugDefaultTargetPlatformOverride = platform;

        expect(TPlatform.isApple, isTrue);
        expect(TPlatform.isGoogle, isFalse);
      }
    });

    test('Should identify each native operating system where it is the target platform', () {
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      const Map<TargetPlatform, (bool, bool, bool, bool, bool)> expectations = {
        TargetPlatform.android: (true, false, false, false, false),
        TargetPlatform.iOS: (false, true, false, false, false),
        TargetPlatform.macOS: (false, false, true, false, false),
        TargetPlatform.linux: (false, false, false, true, false),
        TargetPlatform.windows: (false, false, false, false, true),
      };

      expectations.forEach((platform, value) {
        debugDefaultTargetPlatformOverride = platform;

        expect(TPlatform.isAndroid, value.$1);
        expect(TPlatform.isIOS, value.$2);
        expect(TPlatform.isMacOS, value.$3);
        expect(TPlatform.isLinux, value.$4);
        expect(TPlatform.isWindows, value.$5);
      });
    });

    test('Should report the current compilation target where web status is queried', () {
      expect(TPlatform.isWeb, kIsWeb);
    });
  });
}
