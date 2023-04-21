import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:water_me/app_context.dart';
import 'package:water_me/models/plant_model.dart';
import 'package:water_me/screens/plant_edit.dart';
import 'package:water_me/screens/plant_list_entry.dart';
import 'package:water_me/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';
import '../models/app_model.dart';

class MyPlants extends StatelessWidget {
  const MyPlants({super.key});

  Widget emptyList(BuildContext context) => Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: const [
        SizedBox(height: 100.0),
        Icon(Icons.water_drop_outlined,
            color: Color.fromRGBO(255, 255, 255, 1), size: 150),
        SizedBox(height: 30.0),
        Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Text(
              "Nothing growing yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: 50.0,
                  fontWeight: FontWeight.w400),
            ))
      ]));

  Widget list(BuildContext context, AppModel m) => Container(
      margin: const EdgeInsets.only(top: 0.0),
      // decopration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: m.plants.length,
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
              value: m.plants[index],
              builder: (c, child) {
                var last = index == m.plants.length - 1;
                return PlantListEntry(lastEntry: last);
              });
        },
      ));

  AppBar appBar(BuildContext context) => AppBar(
        elevation: 0.1,
        backgroundColor: c1,
        title: const Text("Plants"),
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(Icons.add),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(value: 0, child: Text("New Plant")),
                  // const PopupMenuItem<int>(value: 1, child: Text("New Group")),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  PlantModel p = PlantModel("", 0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                              value: p,
                              builder: (c, child) {
                                return EditPlant(editMode: EditMode.add);
                              })));
                } else if (value == 1) {
                } else {
                  print("unknown selection: $value");
                }
              }),
          PopupMenuButton(
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Export Plants"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Import Plants"),
              ),
              // const PopupMenuItem<int>(
              //   value: 2,
              //   child: Text("Notification Time"),
              // ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("About"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              onExportJson(context);
            } else if (value == 1) {
              onImportJson(context);
            } else if (value == 2) {
            } else if (value == 3) {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: const Text('About'),
                      content: RichText(
                          text: TextSpan(
                        children: [
                          const TextSpan(
                            style: TextStyle(color: Colors.black),
                            text: "Water-Me is built by abertschi.\n\n",
                          ),
                          TextSpan(
                            style: const TextStyle(color: Colors.black,
                                decoration: TextDecoration.underline),
                            text: "https://abertschi.ch\n\n",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://abertschi.ch?rel=water-me';
                                await launchUrlString(url);
                              },
                          ),
                          TextSpan(
                            style: const TextStyle(color: Colors.black),
                            text: "version ${packageInfo.version}",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://github.com/abertschi/water-me/blob/master/CHANGELOG';
                                await launchUrlString(url);
                              },
                          ),
                        ],
                      ))));
            } else {}
          }),
        ],
      );

  onImportJson(BuildContext context) async {
    final appCtx = Provider.of<AppContext>(context, listen: false);

    importData(BuildContext context) async {
      if (await Permission.storage.request().isGranted) {
        try {
          final file = await appCtx.importModelFromFile();
          print(file);
          RestartWidget.restartApp(context);
        } on Exception catch (e) {
          onShowStatusMessage(
              context, "Failed to import json: ${e.toString()}");
          rethrow;
        }
      }
    }

    var exportPath = await appCtx.exportPath();
    var exportBackup = await appCtx.exportBackupPath();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Importing Plant Data'),
              content: Text('This will overwrite your plants '
                  'with import data from: \n\n$exportPath\n\n A backup '
                  'will be created at: \n\n$exportBackup'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async => {
                    await importData(context),
                  },
                  child: const Text('Proceed'),
                ),
              ],
            ));
  }

  onExportJson(BuildContext context) async {
    final appCtx = Provider.of<AppContext>(context, listen: false);
    if (await Permission.storage.request().isGranted) {
      try {
        final file = await appCtx.exportModelToFile();
        onShowStatusMessage(context, "Exported to ${file.path}");
      } on Exception catch (e) {
        onShowStatusMessage(context, "Failed to export json: ${e.toString()}");
        rethrow;
      }
    }
  }

  onShowStatusMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 7000), content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c1,
        appBar: appBar(context),
        body: Consumer<AppModel>(
            builder: (BuildContext context, AppModel m, Widget? child) {
          return m.plants.isEmpty ? emptyList(context) : list(context, m);
        }));
  }
}
