import 'package:danau_toba/secondPage.dart';
import 'package:flutter/material.dart';

class firstPage extends StatelessWidget {
  const firstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height * 0.75,
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Text(
            "ASAL USUL DANAU TOBA",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff499595)),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Container(
            width: width * 0.8,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff499595)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => secondPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.play_arrow), Text("Play The Audio")],
                )),
          )
        ],
      ),
    );
  }
}
