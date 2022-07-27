import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/plant_model.dart';
import 'package:water_me/screens/plant_edit.dart';
import 'package:water_me/screens/plant_list_entry.dart';
import 'package:water_me/theme.dart';

import '../models/app_model.dart';

class MyPlants extends StatelessWidget {
  const MyPlants({super.key});

  Widget emptyList(BuildContext context) => Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: const [
        SizedBox(height: 100.0),
        Icon(Icons.water_drop_outlined, color: Color.fromRGBO(255, 255, 255, 1), size: 150),
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              PlantModel p = PlantModel("", 0);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: p,
                        builder: (c, child) {
                          return EditPlant(editMode: EditMode.add);
                        })),
              );
            },
          )
        ],
      );

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
