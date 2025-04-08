import 'package:flutter/material.dart';

/// Class that helps with animations
class NexusToolsController extends AnimationController {
  /// Constructor for the [NexusToolsController] class.
  NexusToolsController({required super.vsync, Duration duration = const Duration(milliseconds: 250), super.value})
    : super(lowerBound: 0, upperBound: 1, duration: duration);

  /// Method that shows the animation
  TickerFuture show() => forward();

  /// Method that hides the animation
  TickerFuture hide() => reverse();

  @override
  TickerFuture toggle({double? from}) {
    if (from != null) super.value = from;
    switch (status) {
      case AnimationStatus.completed:
      case AnimationStatus.forward:
        return hide();
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return show();
    }
  }
}
