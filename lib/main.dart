import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BoxOpacitiesModel extends ChangeNotifier {
  final Map<String, double> _boxOpacities = {
    "morning": 0,
    "noon": 0,
    "afternoon": 0,
    "night": 0,
    "evening": 0
  };
  Map<String, double> get boxOpacities => _boxOpacities;

  void updateValue(String key, double newValue) {
    _boxOpacities[key] = newValue;
    notifyListeners();
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => BoxOpacitiesModel(),
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: CupertinoColors.systemBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    void boxPressed({required String caller}) {
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
                  "April 13",
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
