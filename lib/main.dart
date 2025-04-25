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

late File dataFile;
late List<String> dataFileContent;
final String today = DateFormat('dd.MM.yyyy').format(DateTime.now());
late List<String> todaysRow;
late DateTime firstDate; // The first date in the data file. Used to build the graph view.

/// Checks if today's data exists in the data file.
bool todayExists() {
  for (var element in dataFileContent) {
    List<String> row = element.split(" , ");
    if (row[0] == today) {
      todaysRow = List<String>.from(row);
      return true;
    }
  }
  return false;
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
  dataFile = File("${documentsDir.path}/data.csv");

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
    await dataFile.writeAsString("$today , 0.0 , 0.0 , 0.0 , 0.0 , 0.0");
    firstDate = DateFormat("dd.MM.yyyy").parse(today);
  } else {
    // Data file exists. Check if today exists.
    dataFileContent = (await dataFile.readAsString()).split("\n");
    firstDate = DateFormat("dd.MM.yyyy").parse(dataFileContent.first.split(" , ").first);

    if (todayExists()) {
      // Today exists. Set the initial box opacity values based on the data.
      initialOpacities["morning"] = double.parse(todaysRow[1]);
      initialOpacities["noon"] = double.parse(todaysRow[2]);
      initialOpacities["afternoon"] = double.parse(todaysRow[3]);
      initialOpacities["night"] = double.parse(todaysRow[4]);
      initialOpacities["evening"] = double.parse(todaysRow[5]);
    } else {
      // Today does not exist. Create today's line in the data file.
      final sink = dataFile.openWrite(mode: FileMode.append);
      sink.write("\n$today , 0.0 , 0.0 , 0.0 , 0.0 , 0.0");
      await sink.close();
      todaysRow = [
        today,
        '0.0',
        '0.0',
        '0.0',
        '0.0',
        '0.0'
      ];
      dataFileContent.add(todaysRow.join(" , "));
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

      if (caller == "morning") {
        todaysRow[1] = newValue.toString();
      } else if (caller == "noon") {
        todaysRow[2] = newValue.toString();
      } else if (caller == "afternoon") {
        todaysRow[3] = newValue.toString();
      } else if (caller == "night") {
        todaysRow[4] = newValue.toString();
      } else if (caller == "evening") {
        todaysRow[5] = newValue.toString();
      }

      dataFileContent[dataFileContent.length - 1] = todaysRow.join(" , ");
      await dataFile.writeAsString(dataFileContent.join("\n"));

      if (context.mounted) Provider.of<BoxOpacitiesModel>(context, listen: false).updateValue(caller, newValue);
    }

    Widget graphBox({required double boxOpacity, required bool isClickable, String? boxType}) {
      return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: isClickable ? () => boxPressed(caller: boxType!) : null,
          child: Container(
            height: 57.6,
            color: CupertinoColors.activeBlue.withOpacity(boxOpacity),
          ),
        ),
      );
    }

    List<String>? retrieveDatesRow(String date) {
      for (var row in dataFileContent) {
        if (row.split(" , ").first == date) return row.split(" , ");
      }

      return null;
    }

    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, right: 8.0),
            child: ListView.builder(
              reverse: true,
              itemCount: (DateTime.now().difference(firstDate).inDays) + 1,
              itemBuilder: (context, index) {
                DateTime currentDate = firstDate.add(Duration(days: index));
                String cdUIformatted = DateFormat("MMMM dd").format(currentDate);
                String cdFormatted = DateFormat("dd.MM.yyy").format(currentDate);
                List<String> currentDatesRow = retrieveDatesRow(cdFormatted) ??
                    [
                      cdFormatted,
                      "0.0",
                      "0.0",
                      "0.0",
                      "0.0",
                      "0.0"
                    ];

                // only today's row should be a consumer of BoxOpacities model, because you can only update today's boxes.
                if (cdFormatted != today) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(flex: 2, child: Center(child: Text(cdUIformatted))),
                      graphBox(boxOpacity: double.parse(currentDatesRow[1]), isClickable: false),
                      graphBox(boxOpacity: double.parse(currentDatesRow[2]), isClickable: false),
                      graphBox(boxOpacity: double.parse(currentDatesRow[3]), isClickable: false),
                      graphBox(boxOpacity: double.parse(currentDatesRow[4]), isClickable: false),
                      graphBox(boxOpacity: double.parse(currentDatesRow[5]), isClickable: false),
                    ],
                  );
                } else {
                  return Consumer<BoxOpacitiesModel>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex: 2, child: Center(child: Text(cdUIformatted))),
                          graphBox(boxOpacity: value.boxOpacities["morning"]!, isClickable: true, boxType: "morning"),
                          graphBox(boxOpacity: value.boxOpacities["noon"]!, isClickable: true, boxType: "noon"),
                          graphBox(boxOpacity: value.boxOpacities["afternoon"]!, isClickable: true, boxType: "afternoon"),
                          graphBox(boxOpacity: value.boxOpacities["night"]!, isClickable: true, boxType: "night"),
                          graphBox(boxOpacity: value.boxOpacities["evening"]!, isClickable: true, boxType: "evening"),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
