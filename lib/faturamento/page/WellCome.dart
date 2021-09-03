import 'package:flutter/material.dart';

class WellCome extends StatefulWidget {
  @override
  _WellComeState createState() => _WellComeState();
}

class _WellComeState extends State<WellCome> {

  var margin = EdgeInsets.all(0);
  var height = 0.0;
  late Size size;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
         height = size.width * 0.4;
      margin = EdgeInsets.only(top:50);
      });
     
    });
    Future.delayed(Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacementNamed("painel");
      
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            color: Colors.orange.withBlue(100),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  "Bem Vindo(a), ao CardApp!\nAproveite seus 30 dias grátis",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              AnimatedContainer(
                margin: margin,
                height: height,
                duration: Duration(milliseconds: 800),
                curve: Curves.ease,
                child: Image.asset("image/icon.png", width: size.width * 0.3, height: size.width * 0.3,)
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
