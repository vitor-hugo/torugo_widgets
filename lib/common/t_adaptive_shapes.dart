// Copyright (c) torugo.com.br
// Licensed under the MIT License.

import 'package:material_ui/material_ui.dart';
import 'package:twidgets/twidgets.dart';

enum TBorderShape { adaptive, roundedRect, superellipse }

final class TAdaptiveShapes {
  /// Renders [RoundedSuperellipseBorder] on Apple platforms and [RoundedRectangleBorder] otherwise.
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [side]: Border side of the shape. Defaults to [BorderSide.none].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  static ShapeBorder shapeBorder({
    double radius = 0.0,
    BorderSide side = .none,
    TBorderShape shape = TBorderShape.adaptive,
  }) {
    final superellipse = RoundedSuperellipseBorder(
      side: side,
      borderRadius: BorderRadius.circular(radius.clamp(0.0, double.infinity)),
    );
    final roundedRect = RoundedRectangleBorder(
      side: side,
      borderRadius: BorderRadius.circular(radius.clamp(0.0, double.infinity)),
    );

    switch (shape) {
      case .adaptive:
        return TPlatform.isApple ? superellipse : roundedRect;
      case .superellipse:
        return superellipse;
      case .roundedRect:
        return roundedRect;
    }
  }

  /// Renders [RoundedSuperellipseBorder] on Apple platforms or [RoundedRectangleBorder] as [OutlinedBorder].
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [side]: Border side of the shape. Defaults to [BorderSide.none].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  static OutlinedBorder outlinedBorder({
    double radius = 0.0,
    BorderSide side = .none,
    TBorderShape shape = TBorderShape.adaptive,
  }) {
    return shapeBorder(radius: radius, side: side, shape: shape) as OutlinedBorder;
  }

  /// Renders [ClipRSuperellipse] on Apple platforms and [ClipRRect] otherwise.
  ///
  /// - [radius]: Border radius of the shape. Defaults to `0.0`.
  /// - [clipBehavior]: The clip behavior of the shape. Defaults to [Clip.antiAlias].
  /// - [shape]: Set this if you want to force a specific shape. Defaults to [TBorderShape.adaptive].
  /// - [child]: The child of the clip shape.
  static SingleChildRenderObjectWidget clipShape({
    double radius = 0.0,
    Clip clipBehavior = .antiAlias,
    TBorderShape shape = TBorderShape.adaptive,
    Widget? child,
  }) {
    final superellipse = ClipRSuperellipse(
      borderRadius: BorderRadius.circular(radius.clamp(0.0, double.infinity)),
      clipBehavior: clipBehavior,
      child: child,
    );

    final roundedRect = ClipRRect(
      borderRadius: BorderRadius.circular(radius.clamp(0.0, double.infinity)),
      clipBehavior: clipBehavior,
      child: child,
    );

    switch (shape) {
      case .adaptive:
        return TPlatform.isApple ? superellipse : roundedRect;
      case .superellipse:
        return superellipse;
      case .roundedRect:
        return roundedRect;
    }
  }
}
