/// Dart imports
library;
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';


/// Renders the realtime line chart sample.
class LiveLineChart extends StatefulWidget {
  /// Creates the realtime line chart sample.
  const LiveLineChart(this.times,{super.key});

  final String times;

  @override
  _LiveLineChartState createState() => _LiveLineChartState();
}

/// State class of the realtime line chart.
class _LiveLineChartState extends State<LiveLineChart> {
  _LiveLineChartState() {
    timer =
        Timer.periodic(const Duration(milliseconds: 200), _updateDataSource);
  }

  Timer? timer;
  List<_ChartData>? chartData;
  late int count;
  ChartSeriesController<_ChartData, int>? _chartSeriesController;

  @override
  void dispose() {
    timer?.cancel();
    chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }

  @override
  void initState() {
    count = 19;
    chartData = <_ChartData>[
      _ChartData(0, 0),
      _ChartData(1, 0),
      _ChartData(2, 0),
      _ChartData(3, 0),
      _ChartData(4, 0),
      _ChartData(5, 0),
      _ChartData(6, 0),
      _ChartData(7, 0),
      _ChartData(8, 0),
      _ChartData(9, 0),
      _ChartData(10, 0),
      _ChartData(11, 0),
      _ChartData(12, 0),
      _ChartData(13, 0),
      _ChartData(14, 0),
      _ChartData(15, 0),
      _ChartData(16, 0),
      _ChartData(17, 0),
      _ChartData(18, 0),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  /// Returns the realtime Cartesian line chart.
  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: const NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0)),
        series: <LineSeries<_ChartData, int>>[
          LineSeries<_ChartData, int>(
            onRendererCreated:
                (ChartSeriesController<_ChartData, int> controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData sales, _) => sales.country,
            yValueMapper: (_ChartData sales, _) => sales.sales,
            animationDuration: 0,
          )
        ]);
  }

  ///Continuously updating the data source based on timer
  void _updateDataSource(Timer timer) {
    // debugPrint(int.parse(widget.times).toString());
    // if (isCardView != null) {
      // chartData!.add(_ChartData(count, _getRandomInt(10, 100)));
      chartData!.add(_ChartData(count, int.parse(widget.times) > 10 ? int.parse(widget.times) : 0));
      if (chartData!.length == 20) {
        chartData!.removeAt(0);
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );
      } else {
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData!.length - 1],
        );
      }
      count = count + 1;
    // }
  }

  ///Get the random data
  int _getRandomInt(int min, int max) {
    final math.Random random = math.Random();
    return min + random.nextInt(max - min);
  }
}

/// Private class for storing the chart series data points.
class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final num sales;
}