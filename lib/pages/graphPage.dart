//Layout
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_chart/model/line-chart.model.dart' as package;
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:line_chart/charts/line-chart.widget.dart';

class GraphPage extends StatefulWidget {
  static const routeName = "/graphPage";

  State<StatefulWidget> createState() => _GraphPage();
}

class _GraphPage extends State {
  int _selectedIndex;
  List<Measurement> tempList;
  List<package.LineChartModel> dataList = [];

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTempList();
  }

  _getTempList() {
    MeasurementApi.getMeasurementsFromSensor(4).then((result) {
      setState(() {
        print("testjeee");
        tempList = result;

        for (Measurement m in tempList) {
          dataList.add(new package.LineChartModel(
              date: DateTime.parse(m.timestamp),
              amount: double.parse(m.value)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(tabName: 'Temperatuur van de lucht'),
      body: _tempListItems(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: null,
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
            elevation: 2.0,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: _selectedTab,
        items: [
          CustomAppBarItem(icon: Icons.home),
          CustomAppBarItem(icon: Icons.graphic_eq),
          CustomAppBarItem(icon: Icons.add_alert),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _tempListItems() {
    if (tempList == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else {
      return LineChart(
        width: 300, // Width size of chart
        height: 180, // Height size of chart
        data: dataList, // The value to the chart
        linePaint: Paint()
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..color = Colors.black, // Custom paint for the line
        circlePaint: Paint()..color = Colors.black, // Custom paint for the line
        showPointer:
            true, // When press or pan update the chart, create a pointer in approximated value (The default is true)
        showCircles: true, // Show the circle in every value of chart
        customDraw: (Canvas canvas,
            Size
                size) {}, // You can draw anything in your chart, this callback is called when is generating the chart
        circleRadiusValue: 6, // The radius value of circle
        linePointerDecoration: BoxDecoration(
          color: Colors.black,
        ), // Your line pointer decoration,
        pointerDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ), // Your decoration of circle pointer,
        insideCirclePaint: Paint()
          ..color = Colors
              .white, // On your circle of the chart, have a second circle, which is inside and a slightly smaller size.
        /*onValuePointer: (MonthChartModel value) {
          print('onValuePointer');
        },*/ // This callback is called when change the pointer,
        onDropPointer: () {
          print('onDropPointer');
        }, // This callback is called when it is on the pointer and removes your finger from the screen
      );
    }
  }
}
