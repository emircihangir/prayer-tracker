import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class BoxOpacitiesModel extends ChangeNotifier {
  final Map<String, double> _boxOpacities;
  BoxOpacitiesModel({required Map<String, double> initialValue}) : _boxOpacities = initialValue;
  Map<String, double> get boxOpacities => _boxOpacities;

  void updateValue(String key, double newValue) {
    _boxOpacities[key] = newValue;
    notifyListeners();
  }

  void updateValueSilently(String key, double newValue) => _boxOpacities[key] = newValue;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: CupertinoColors.systemBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  Directory documentsDir = await getApplicationDocumentsDirectory();
  File dataFile = File("${documentsDir.path}/data.csv");
  final String today = DateFormat('dd.MM.yyyy').format(DateTime.now());
  Map<String, double> initialOpacities = {
    "morning": 0,
    "noon": 0,
    "afternoon": 0,
    "night": 0,
    "evening": 0
  };

  // Check if data file exists.
  if (await dataFile.exists() == false) {
    // Data file does not exists. First time user.
    print("Data file does not exists. First time user.");
    await dataFile.writeAsString("$today , 0 , 0 , 0 , 0 , 0");
  } else {
    // Data file exists. Check if today exists.
    List<String> dataFileContent = (await dataFile.readAsString()).split("\n");
    List<String>? todaysRow;
    for (var element in dataFileContent) {
      List<String> row = element.split(" , ");
      if (row[0] == today) {
        todaysRow = List<String>.from(row);
        break;
      }
    }
    if (todaysRow != null) {
      // Today exists. Set the initial box opacity values based on the data.
      print("Today exists. Setting the initial box opacity values based on the data.");
      initialOpacities["morning"] = double.parse(todaysRow[1]);
      initialOpacities["noon"] = double.parse(todaysRow[2]);
      initialOpacities["afternoon"] = double.parse(todaysRow[3]);
      initialOpacities["night"] = double.parse(todaysRow[4]);
      initialOpacities["evening"] = double.parse(todaysRow[5]);
    } else {
      // Today does not exist. Create today's line in the data file.
      print("Today does not exist. Creating today's line in the data file.");
      String todaysLine = "$today , 0 , 0 , 0 , 0 , 0";
      final sink = dataFile.openWrite(mode: FileMode.append);
      sink.write("\n$todaysLine");
      await sink.close();
    }
  }

  runApp(ChangeNotifierProvider(
    create: (context) => BoxOpacitiesModel(initialValue: initialOpacities),
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    void boxPressed({required String caller}) async {
      double currentValue = Provider.of<BoxOpacitiesModel>(context, listen: false).boxOpacities[caller]!;
      double newValue = ((currentValue == 1) ? 0 : 1) * (currentValue + 0.5);

      Provider.of<BoxOpacitiesModel>(context, listen: false).updateValue(caller, newValue);
    }

    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM d').format(DateTime.now()),
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Morning prayer"),
                    GestureDetector(
                      onTap: () => boxPressed(caller: "morning"),
                      child: Consumer<BoxOpacitiesModel>(
                        builder: (context, value, child) {
                          return Container(
                            width: 30,
                            height: 50,
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue.withOpacity(value.boxOpacities["morning"]!),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Noon prayer"),
                    GestureDetector(
                      onTap: () => boxPressed(caller: "noon"),
                      child: Consumer<BoxOpacitiesModel>(
                        builder: (context, value, child) {
                          return Container(
                            width: 30,
                            height: 50,
                            decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(value.boxOpacities["noon"]!)),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Afternoon prayer"),
                    GestureDetector(
                      onTap: () => boxPressed(caller: "afternoon"),
                      child: Consumer<BoxOpacitiesModel>(
                        builder: (context, value, child) {
                          return Container(
                            width: 30,
                            height: 50,
                            decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(value.boxOpacities["afternoon"]!)),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Night prayer"),
                    GestureDetector(
                      onTap: () => boxPressed(caller: "night"),
                      child: Consumer<BoxOpacitiesModel>(
                        builder: (context, value, child) {
                          return Container(
                            width: 30,
                            height: 50,
                            decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(value.boxOpacities["night"]!)),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Evening prayer"),
                    GestureDetector(
                      onTap: () => boxPressed(caller: "evening"),
                      child: Consumer<BoxOpacitiesModel>(
                        builder: (context, value, child) {
                          return Container(
                            width: 30,
                            height: 50,
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue.withOpacity(value.boxOpacities["evening"]!),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
