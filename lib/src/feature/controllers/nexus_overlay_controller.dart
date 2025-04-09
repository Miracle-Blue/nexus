import 'package:flutter/material.dart';

import '../../../nexus.dart';
import '../../common/utils/nexus_animation_controller.dart';
import 'nexus_logs_controller.dart';

/// Abstract class that extends [State] and [SingleTickerProviderStateMixin] and helps to control the [Nexus]
abstract class NexusOverlayController extends State<Nexus> with SingleTickerProviderStateMixin {
  /// Animation controller for the [Nexus]
  late final NexusToolsController controller;

  /// The width of the handle
  double handleWidth = 16;

  /// Whether the overlay is dismissed
  bool dismissed = true;

  @override
  void initState() {
    super.initState();
    controller = NexusToolsController(value: 0, duration: widget.duration, vsync: this);
    controller.addStatusListener(_onStatusChanged);
    _onStatusChanged(controller.status);
  }

  @override
  void didUpdateWidget(covariant Nexus oldWidget) {
    if (widget.enabled) {
      dismissed = controller.status == AnimationStatus.dismissed;
    } else {
      dismissed = true;
    }
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();

    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) => switch (status) {
    _ when !mounted => null,
    AnimationStatus.dismissed => () {
      if (dismissed) return;
      setState(() => dismissed = true);

      if (NexusLogsController.searchEnabled) NexusLogsController.toggleSearch();

      // Unfocus keyboard when the overlay is dismissed
      FocusManager.instance.primaryFocus?.unfocus();
    }(),
    _ => () {
      if (!dismissed) return;
      setState(() => dismissed = false);
    }(),
  };

  /// Method that handles the horizontal drag update
  void onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (dismissed) return;

    final delta = details.delta.dx;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    if (dismissed && (isRtl ? delta < 0 : delta > 0) || !dismissed && (isRtl ? delta > 0 : delta < 0)) {
      final newValue = controller.value + delta / width * (isRtl ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }

    if (dismissed && (isLtr ? delta < 0 : delta > 0) || !dismissed && (isLtr ? delta > 0 : delta < 0)) {
      final newValue = controller.value - delta / width * (isLtr ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }
  }

  /// Method that handles the horizontal drag end
  void onHorizontalDragEnd(DragEndDetails details) {
    if (dismissed) return;

    final velocity = details.primaryVelocity ?? 0;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if ((isRtl ? -velocity : velocity) > 300 || controller.value > 0.5) {
      controller.show();
    } else {
      controller.hide();
    }
  }
}
