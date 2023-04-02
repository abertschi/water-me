import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/app_model.dart';
import 'package:water_me/screens/plant_list.dart';
import 'package:water_me/theme.dart';

import 'app_context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppContext c = AppContext();
  await c.init();
  runApp(RestartWidget(child: MyApp(appContext: c)));
}

class MyApp extends StatefulWidget {
  final AppContext appContext;

  MyApp({super.key, required this.appContext}) {}

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>.value(value: widget.appContext.model!),
        Provider<AppContext>.value(value: widget.appContext),
      ],
      child: MaterialApp(
        title: 'Water me',
        theme: appTheme,
        initialRoute: '/myplants',
        routes: <String, WidgetBuilder>{
          '/myplants': (context) => MyPlants(),
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    widget.appContext.saveModel();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class RestartWidget extends StatefulWidget {
  // taken from:
  // https://stackoverflow.com/questions/50115311/how-to-force-a-flutter-application-restart-in-production-mode
  // we wrap our app into this to force redraw of app
  // when replacing the instance of appCtx.model upon restore from file feature.
  // redraw with: RestartWidget.restartApp(context).

  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
