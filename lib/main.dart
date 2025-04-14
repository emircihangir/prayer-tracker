import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
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

    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    const Text("Morning"),
                    Container(
                      width: 30,
                      height: 50,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Noon"),
                    Container(
                      width: 30,
                      height: 50,
                      decoration: BoxDecoration(color: CupertinoColors.activeBlue),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Afternoon"),
                    Container(
                      width: 30,
                      height: 50,
                      decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(0.5)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Night"),
                    Container(
                      width: 30,
                      height: 50,
                      decoration: BoxDecoration(color: CupertinoColors.activeBlue),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Evening"),
                    Container(
                      width: 30,
                      height: 50,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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
