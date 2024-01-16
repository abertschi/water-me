import 'dart:io';
import 'dart:math';

import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/app_model.dart';
import 'package:water_me/models/plant_model.dart';
import 'package:water_me/theme.dart';

import 'plant_edit.dart';

class ShowPlant extends StatelessWidget {
  const ShowPlant({super.key});

  void onWatering(BuildContext context, PlantModel plant) {
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
  }

  Widget buildBody(BuildContext context) {
    final plant = Provider.of<PlantModel>(context);

    const descTextSize =
        TextStyle(color: Color.fromRGBO(243, 243, 243, 1.0), fontSize: 21.0);

    const descTextBold = TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(243, 243, 243, 1.0),
        fontSize: 21.0);

    const descTextSmall = TextStyle(
        fontWeight: FontWeight.normal,
        color: Color.fromRGBO(243, 243, 243, 1.0),
        fontSize: 18.0);

    final topText = SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // const SizedBox(height: 60.0),
        // const Icon(
        //   Icons.water_drop_outlined,
        //   color: Colors.white,
        //   size: 60.0,
        // ),
        // const SizedBox(height: 30.0),
        Text(
          plant.plantName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50.0,
          ),
        ),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(children: [
            const Text(
              "water ",
              style: descTextSize,
            ),
            Container(
              // padding: const EdgeInsets.all(7.0),
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text(
                "every ${plant.wateringFrequency} days",
                style: descTextBold,
              ),
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child:
                buildWateredText(context, plant, descTextSize, descTextBold)),
        const SizedBox(height: 60.0),
        Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: buttonTemplate(
                text: "WATER NOW",
                onPressed: () => onWatering(context, plant))),
        const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Divider(
              color: Color.fromRGBO(255, 255, 255, 0.7607843137254902),
              thickness: 1.0,
            )),
        const SizedBox(height: 30.0),
        const Text(
          "History",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: min(plant.wateringHistory.length, 5),
                itemBuilder: (BuildContext context, int index) {
                  var last = plant.wateringHistory.length - index - 1;
                  return Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "\u2022  watered ${timeago.format(plant.wateringHistory[last])}",
                        style: descTextSmall,
                      ));
                })),
      ],
    ));

    Widget image = const Text("");
    if (plant.image != null && plant.image!.isNotEmpty) {
      image = Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(plant.image!)),
              fit: BoxFit.cover,
            ),
          ));
    }

    return Stack(
      children: <Widget>[
        image,
        Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
              top: 0.0, right: 40.0, left: 40.0, bottom: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(49, 73, 60, 0.6)),
          child: Center(
            child: topText,
          ),
        ),
        Positioned(
          left: 30.0,
          top: 50.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 35.0,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: buildOptionsButton(context, plant)),
        ),
      ],
    );
  }

  buildWateredText(BuildContext context, PlantModel plant,
      TextStyle descTextSize, TextStyle descTextBold) {
    if (plant.lastWatered() != null) {
      return Row(
        children: [
          Text(
            "watered ",
            style: descTextSize,
          ),
          Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            // padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(
              timeago.format(plant.lastWatered() as DateTime),
              style: descTextBold,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "never watered yet",
            style: descTextSize,
          ),
        ],
      );
    }
  }

  Widget buildOptionsButton(BuildContext context, PlantModel plant) {
    var options = <String>['Edit', 'Delete'];

    void onSelect(item) {
      switch (item) {
        case 'Edit':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                    value: plant,
                    builder: (c, child) {
                      return EditPlant(editMode: EditMode.edit);
                    })),
          );
          break;
        case 'Delete':
          Provider.of<AppModel>(context, listen: false).removePlant(plant);
          Navigator.pop(context);
          break;
      }
    }

    return PopupMenuButton<String>(
        color: Colors.white,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        onSelected: onSelect,
        itemBuilder: (BuildContext context) {
          return options.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }
}
