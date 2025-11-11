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

class ThemedApp extends StatelessWidget {
  final String title;
  final String? fontFamily;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final TransitionBuilder? builder;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale>? supportedLocales;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
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
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
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
