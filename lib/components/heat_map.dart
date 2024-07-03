import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout/data/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({super.key, required this.datasets, required this.startDateYYYYMMDD,});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateFromString(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 30)),
        datasets:datasets,
        colorMode: ColorMode.color,
        defaultColor:Colors.grey[200],
        textColor: Color.fromARGB(255, 0, 0, 0),
        showColorTip: false,
        showText: false,
        scrollable: true,
        size: 30,
        colorsets: const{
          1: Colors.green,
        },
      ),
    );
  }
}
