import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final List bpm;
  final List time;
  final int len;
  Chart(this.bpm, this.time,this.len);
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
   List y = widget.bpm;
   List z = widget.time;
   int len = widget.len - 34;
   List graphing =[];
   for (int i = 1; i <= 33; i++){
     graphing.add(SalesData(y[len + i], z[len + i]));
   }

    return Scaffold(
        appBar: AppBar(
          title: Text("Chart Data"),
        ),
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    title: ChartTitle(text: 'Bpm Against Time'),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(isVisible: true),
                    primaryXAxis: CategoryAxis(),

                    series: <ChartSeries>[
                      // Initialize line series
                      SplineSeries<SalesData, String>(

                        dataSource: [
                          graphing[0],
                          graphing[1],
                          graphing[2],
                          graphing[3],
                          graphing[4],
                          graphing[5],
                          graphing[6],
                          graphing[7],
                          graphing[8],
                          graphing[9],
                          graphing[10],
                          graphing[11],
                          graphing[12],
                          graphing[13],
                          graphing[14],
                          graphing[15],
                          graphing[16],
                          graphing[17],
                          graphing[18],
                          graphing[19],
                          graphing[20],
                          graphing[21],
                          graphing[22],
                          graphing[23],
                          graphing[24],
                          graphing[25],
                          graphing[26],
                          graphing[27],
                          graphing[28],
                          graphing[29],
                          graphing[30],
                          graphing[31],
                          graphing[32],
                        ],
                        xValueMapper: (SalesData data, _) => data.time,
                        yValueMapper: (SalesData data, _) => data.bpm,
                        dataLabelSettings:DataLabelSettings(isVisible : true),
                        name: 'Bpm',
                        trendlines:<Trendline>[
                          Trendline(
                              type: TrendlineType.polynomial,
                              color: Colors.blue)
                        ],
                      )
                    ]

                )
            )
        )
    );
  }
}

class SalesData{
  SalesData(this.bpm, this.time);
  final double bpm;
  final String time;
}

