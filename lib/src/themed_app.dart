import 'package:flutter/material.dart'
    show
        BuildContext,
        Locale,
        LocalizationsDelegate,
        MaterialApp,
        NavigatorObserver,
        RouteFactory,
        StatelessWidget,
        ThemeData,
        TransitionBuilder,
        ValueListenableBuilder,
        Widget,
        WidgetBuilder;

import 'flutter_theme_manager.dart' show ThemeManager;

/// A drop-in replacement for [MaterialApp] that automatically handles theme changes.
///
/// ThemedApp wraps [MaterialApp] and listens to [ThemeManager] for theme updates.
/// All standard [MaterialApp] parameters are supported.
///
/// **Important:** Do not set [MaterialApp.theme] or [MaterialApp.darkTheme]
/// manually, as [ThemeManager] controls these automatically.
class ThemedApp extends StatelessWidget {
  /// The title of the application.
  ///
  /// Used by the OS for task switcher and accessibility.
  final String title;

  /// Optional font family to apply to all text in the theme.
  ///
  /// This overrides the font family from the active theme.
  final String? fontFamily;

  /// The widget for the default route of the app.
  final Widget? home;

  /// The application's top-level routing table.
  final Map<String, WidgetBuilder>? routes;

  /// The name of the first route to show.
  final String? initialRoute;

  /// The route generator callback for when [routes] doesn't contain a route.
  final RouteFactory? onGenerateRoute;

  /// Called when [onGenerateRoute] fails to generate a route.
  final RouteFactory? onUnknownRoute;

  /// The list of observers for the [Navigator] created for this app.
  final List<NavigatorObserver>? navigatorObservers;

  /// A builder that can wrap the app's widgets.
  final TransitionBuilder? builder;

  /// The locale for this app.
  final Locale? locale;

  /// The delegates for this app's localization.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The list of locales that this app has been localized for.
  final Iterable<Locale>? supportedLocales;

  /// Whether to show the debug banner in debug mode.
  final bool debugShowCheckedModeBanner;

  /// Whether to show the material grid in debug mode.
  final bool debugShowMaterialGrid;

  /// Whether to show the performance overlay.
  final bool showPerformanceOverlay;

  /// Whether to checkerboard raster cache images.
  final bool checkerboardRasterCacheImages;

  /// Whether to checkerboard offscreen layers.
  final bool checkerboardOffscreenLayers;

  /// Whether to show the semantics debugger.
  final bool showSemanticsDebugger;

  const ThemedApp({
    super.key,
    required this.title,
    this.fontFamily,
    this.home,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.builder,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en')],
    this.debugShowCheckedModeBanner = true,
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: ThemeManager.instance.themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: title,
          theme: theme.copyWith(
            textTheme: theme.textTheme.apply(
              fontFamily: fontFamily,
            ),
          ),
          home: home,
          routes: routes ?? {},
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: navigatorObservers ?? const [],
          builder: builder,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales ?? const [Locale('en')],
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
        );
      },
    );
  }
}
