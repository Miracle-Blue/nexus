// ignore_for_file: cascade_invocations

import 'dart:math' as math;

import 'package:dio/dio.dart' show Dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template octopus_tools}
/// Display the Octopus tools widget.
/// Helpful for router debugging.
/// {@endtemplate}
class Nexus extends StatefulWidget {
  /// {@macro octopus_tools}
  const Nexus({
    required this.child,
    this.dio,
    this.enable = kDebugMode,
    this.duration = const Duration(milliseconds: 250),
    super.key,
  });

  /// Enable the NexusTools widget.
  final bool enable;

  /// The Octopus instance.
  final Dio? dio;

  /// Animation duration.
  final Duration duration;

  /// The child widget.
  final Widget child;

  @override
  State<Nexus> createState() => _NexusState();
}

class _NexusState extends State<Nexus> with SingleTickerProviderStateMixin {
  late final _NexusToolsController _controller;
  static const double handleWidth = 16;
  bool dismissed = true;

  @override
  void initState() {
    super.initState();
    _controller = _NexusToolsController(
      value: 0,
      duration: widget.duration,
      vsync: this,
    );
    _controller.addStatusListener(_onStatusChanged);
    _onStatusChanged(_controller.status);
  }

  @override
  void didUpdateWidget(covariant Nexus oldWidget) {
    if (widget.enable) {
      dismissed = _controller.status == AnimationStatus.dismissed;
    } else {
      dismissed = true;
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    switch (status) {
      case AnimationStatus.dismissed:
        if (dismissed) return;
        setState(() => dismissed = true);
      default:
        if (!dismissed) return;
        setState(() => dismissed = false);
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  Widget _materialContext({required Widget child}) => /* AnimatedTheme */ Theme(
        data: ThemeData.dark(),
        /* duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut, */
        child: Row(
          children: <Widget>[
            // Tools
            Expanded(
              child: Visibility(
                visible: !dismissed,
                maintainState: true,
                maintainAnimation: false,
                maintainSize: false,
                maintainInteractivity: false,
                maintainSemantics: false,
                child: Material(
                  elevation: 0,
                  child: DefaultSelectionStyle(
                    child: ScaffoldMessenger(
                      child: HeroControllerScope.none(
                        child: Navigator(
                          pages: <Page<void>>[
                            MaterialPage<void>(
                              child: Scaffold(
                                body: SafeArea(
                                  child: child,
                                ),
                              ),
                            ),
                          ],
                          onDidRemovePage: (page) {},
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Handle
            Align(
              alignment: Alignment(0, -0.4),
              child: SizedBox(
                width: handleWidth,
                height: 64,
                child: Material(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                  elevation: 0,
                  child: InkWell(
                    onTap: () => _controller.toggle(),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    child: Center(
                      child: RotationTransition(
                        turns: _controller.drive(
                          Tween<double>(
                            begin: 0,
                            end: 0.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => !widget.enable
      ? widget.child
      : LayoutBuilder(
          builder: (context, constraints) {
            final biggest = constraints.biggest;
            final width = math.min<double>(320, biggest.width * 0.85);
            return Stack(
              children: <Widget>[
                // Content
                widget.child,
                // ModalBarrier
                if (!dismissed)
                  AnimatedModalBarrier(
                    color: _controller.drive(
                      ColorTween(
                        begin: Colors.transparent,
                        end: Colors.black.withAlpha(127),
                      ),
                    ),
                    dismissible: true,
                    semanticsLabel: 'Dismiss',
                    onDismiss: () => _controller.hide(),
                  ),
                // ToolBar
                PositionedTransition(
                  rect: _controller.drive(
                    RelativeRectTween(
                      begin: RelativeRect.fromLTRB(
                        handleWidth - width,
                        0,
                        biggest.width - handleWidth,
                        0,
                      ),
                      end: RelativeRect.fromLTRB(
                        0,
                        0,
                        biggest.width - width,
                        0,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: width,
                    child: _materialContext(
                      child: SizedBox.expand(
                        child: ColoredBox(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
}

class _NexusToolsController extends AnimationController {
  _NexusToolsController({
    required super.vsync,
    Duration duration = const Duration(milliseconds: 250),
    super.value, // ignore: unused_element
  }) : super(
          lowerBound: 0,
          upperBound: 1,
          duration: duration,
        );

  TickerFuture show() => forward();

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
