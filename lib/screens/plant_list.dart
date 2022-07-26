import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/plant_model.dart';
import 'package:water_me/screens/plant_edit.dart';
import 'package:water_me/screens/plant_list_entry.dart';
import 'package:water_me/theme.dart';

import '../models/app_model.dart';

class MyPlants extends StatelessWidget {
  const MyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    final list = Container(
        margin: const EdgeInsets.only(top: 0.0),
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: Consumer<AppModel>(
            builder: (BuildContext context, AppModel m, Widget? child) {
          return ListView.builder(
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
          );
        }));

    final appBar = AppBar(
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

    return Scaffold(backgroundColor: c1, appBar: appBar, body: list);
  }
}
