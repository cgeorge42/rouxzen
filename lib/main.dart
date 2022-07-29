import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:rouxzen/cube_panel.dart';

import 'app.dart';
import 'cube_command.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<RouxApp>(create: (_) => RouxApp())],
      child: MaterialApp(
        title: 'Practicing the Zen of Roux',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<RouxApp>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('The Zen of Roux'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Observer(builder: (_) {
              return CubePanel(
                app.cube,
                app.cubeStyle,
                Size(250, 250),
                view: CubePanelView.cube,
              );
            })
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          FloatingActionButton(
            onPressed: () => app.cube.push(CubeCommand.reset()),
            tooltip: 'Reset',
            child: Icon(Icons.cached),
          ),
          Padding(padding: EdgeInsets.only(left: 20)),
          FloatingActionButton(
            onPressed: () => app.cube.scramble(),
            tooltip: 'Scramble',
            child: Icon(Icons.shuffle),
          )
        ],
      ),
    );
  }
}
