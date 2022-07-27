import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/screens/plant_show.dart';

import '../models/plant_model.dart';

class PlantListEntry extends StatelessWidget {
  final cardHeight = 90.0;
  final bool lastEntry;

  const PlantListEntry({this.lastEntry = false});

  onShowPlantDetails(BuildContext context, PlantModel plant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
                value: plant, builder: (c, child) => ShowPlant())));
  }

  Future<bool> onSwipe(BuildContext context, PlantModel plant) async {
    plant.waterNow();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 5000),
        content: Text("Plant ${plant.plantName} watered."),
        action: SnackBarAction(
            label: "UNDO",
            textColor: Colors.white,
            onPressed: () {
              plant.undoWatering();
            })));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final plant = Provider.of<PlantModel>(context);
    return Dismissible(
      key: UniqueKey(),
      background: buildSwipeWidget(context),
      secondaryBackground: buildSwipeWidget(context),
      confirmDismiss: (_) => onSwipe(context, plant),
      onDismissed: (_) {},
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.only(
            left: 10.0, right: 10.0, top: 6.0, bottom: lastEntry ? 50.0 : 6.0),
        child: Stack(children: <Widget>[
          buildBackgroundContainer(context, plant),
          Container(
            height: cardHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color.fromRGBO(49, 73, 60, plant.hasImage ? 0.5 : 0.9)),
            child: Center(
              child: buildListTile(context, plant),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildListTile(BuildContext context, PlantModel plant) {
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Icon(
            plant.isWateringDue()
                ? Icons.warning_amber_outlined
                : Icons.water_drop_outlined,
            color: plant.isWateringDue()
                ? Color.fromRGBO(255, 46, 42, 0.9)
                : Colors.white,
            size: 40,
          ),
        ),
        title: Text(
          plant.plantName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              "${plant.daysUntilNextWatering()} days left",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
        trailing: const Icon(Icons.keyboard_arrow_right,
            color: Colors.white, size: 30.0),
        onTap: () => onShowPlantDetails(context, plant));
  }

  Widget buildSwipeWidget(BuildContext context) {
    const padding = 15.0;
    return Container(
      color: const Color.fromARGB(113, 37, 63, 87),
      child: Padding(
        padding: const EdgeInsets.only(
            left: padding, right: padding, top: padding, bottom: padding),
        child: Row(
          children: const <Widget>[
            Text('Mark as watered', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildBackgroundContainer(BuildContext context, PlantModel plant) {
    if (plant.image != null && plant.image!.isNotEmpty) {
      return Container(
          height: cardHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(plant.image!)),
              fit: BoxFit.cover,
            ),
          ));
    }
    return const Text("");
  }
}
