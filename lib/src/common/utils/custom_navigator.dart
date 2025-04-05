import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../extension/context_extension.dart';

/// {@template navigator_scope}
/// NavigatorScope widget.
/// {@endtemplate}
class NavigatorScope extends StatefulWidget {
  /// {@macro navigator_scope}
  const NavigatorScope({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  static void change(BuildContext context, List<Page<Object?>> Function(List<Page<Object?>> pages) fn) =>
      context.inhOf<_InheritedNavigatorScope>().state.change(fn);

  static List<Page<Object?>> pagesOf(BuildContext context) =>
      context.inhOf<_InheritedNavigatorScope>().state._pages.toList(growable: false);

  @override
  State<NavigatorScope> createState() => _NavigatorScopeState();
}

/// State for widget NavigatorScope.
class _NavigatorScopeState extends State<NavigatorScope> {
  List<Page<Object?>> _pages = <Page<Object?>>[];

  void change(List<Page<Object?>> Function(List<Page<Object?>> page) fn) {
    if (!context.mounted) return;

    final newPages = fn(_pages);

    if (identical(newPages, _pages)) return;
    if (newPages.isEmpty) return;
    if (listEquals(newPages, _pages)) return;

    setState(() => _pages = newPages);
  }

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    _pages.add(MaterialPage<Object?>(key: const ValueKey<String>('initial_child'), child: widget.child));
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => _InheritedNavigatorScope(
    state: this,
    child: Navigator(
      pages: _pages,
      onDidRemovePage:
          (page) => WidgetsBinding.instance.addPostFrameCallback((d) => setState(() => _pages.remove(page))),
    ),
  );
}

/// Inherited widget for quick access in the element tree.
class _InheritedNavigatorScope extends InheritedWidget {
  const _InheritedNavigatorScope({required this.state, required super.child});

  final _NavigatorScopeState state;

  @override
  bool updateShouldNotify(covariant _InheritedNavigatorScope oldWidget) => state != oldWidget.state;
}
