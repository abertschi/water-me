import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/plant_model.dart';
import 'package:water_me/screens/take_picture.dart';

import '../app_context.dart';
import '../main.dart';
import '../theme.dart';

enum EditMode { add, edit }

class EditPlant extends StatefulWidget {
  final EditMode editMode;

  EditPlant({super.key, this.editMode = EditMode.edit});

  @override
  State<StatefulWidget> createState() {
    return _EditPlant();
  }
}

class _EditPlant extends State<EditPlant> {
  late TextEditingController plantNameCtrl;
  late TextEditingController frequencyCtrl;
  final formKey = GlobalKey<FormState>();
  var roundedBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.white));

  _EditPlant();

  @override
  void initState() {
    super.initState();
    final plant = Provider.of<PlantModel>(context, listen: false);
    plantNameCtrl = TextEditingController(text: plant.plantName ?? "");
    plantNameCtrl.addListener(() {
      plant.plantName = plantNameCtrl.text;
    });

    frequencyCtrl =
        TextEditingController(text: plant.wateringFrequency.toString());
    frequencyCtrl.addListener(() {
      plant.wateringFrequency = int.tryParse(frequencyCtrl.text) ?? 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    plantNameCtrl.dispose();
    frequencyCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[body(context)],
          )),
    );
  }

  onSave(BuildContext context, PlantModel plant) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      // Validation errors
      return;
    }

    var model = Provider.of<AppContext>(context, listen: false).model!;
    if (!model.plants.contains(plant)) {
      model.addPlant(plant);
    }
    Provider.of<AppContext>(context, listen: false).saveModel();
    Navigator.pop(context);
  }

  onDelete(BuildContext context, PlantModel plant) async {
    var model = Provider.of<AppContext>(context, listen: false).model!;
    model.removePlant(plant);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  onTakePicture(BuildContext context, PlantModel plant) async {
    var c = Provider.of<AppContext>(context, listen: false).camera!;
    final image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(camera: c)),
    );
    if (image != null && image is String) {
      plant.image = image;
    }
  }

  Widget saveButton(BuildContext contex, PlantModel plant) {
    return buttonTemplate(
        text: "SAVE", onPressed: () => onSave(context, plant));
  }

  Widget deleteButton(BuildContext contex, PlantModel plant) {
    return buttonTemplate(
        text: "DELETE", onPressed: () => onDelete(context, plant));
  }

  Widget body(BuildContext context) {
    final plant = Provider.of<PlantModel>(context);

    final topText = SingleChildScrollView(
        child: Column(
      children: <Widget>[
        const SizedBox(height: 100.0),
        const Icon(
          Icons.water_drop_outlined,
          color: Colors.white,
          size: 80.0,
        ),
        const SizedBox(height: 40.0),
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          enterName(context),
          const SizedBox(height: 40.0),
          enterFrequency(context),
          const SizedBox(height: 40.0),
          buttonTemplate(
              text: "TAKE PICTURE",
              onPressed: () => onTakePicture(context, plant)),
          const SizedBox(height: 40.0),
          widget.editMode == EditMode.edit
              ? deleteButton(context, plant)
              : saveButton(context, plant),
        ])
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

    return Expanded(
        child: Stack(
      children: <Widget>[
        image,
        Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
              top: 40.0, right: 40.0, left: 40.0, bottom: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(49, 73, 60, 0.6)),
          child: topText,
        ),
        Positioned(
          left: 30.0,
          top: 60.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ],
    ));
  }

  Widget enterName(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: TextFormField(
          controller: plantNameCtrl,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "Can't be empty";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "ENTER NAME",
            errorStyle: TextStyle(color: Colors.white),
            suffixStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            border: roundedBorder,
            focusedErrorBorder: roundedBorder,
            errorBorder: roundedBorder,
            enabledBorder: roundedBorder,
            focusedBorder: roundedBorder,
            fillColor: Colors.white,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      );

  Widget enterFrequency(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: TextFormField(
          controller: frequencyCtrl,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return "Can't be empty";
            } else {
              var num = int.tryParse(v);
              if (num == null || num <= 0) {
                return "Must be a positive number";
              } else {
                return null;
              }
            }
          },
          decoration: InputDecoration(
            suffixText: "days ",
            labelText: "FREQUENCY",
            errorStyle: TextStyle(color: Colors.white),
            suffixStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            border: roundedBorder,
            focusedErrorBorder: roundedBorder,
            errorBorder: roundedBorder,
            enabledBorder: roundedBorder,
            focusedBorder: roundedBorder,
            fillColor: Colors.white,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      );

  Widget takePicture(BuildContext context) => Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5.0)),
        child: const Text(
          "TAKE PICTURE",
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
      );
}
