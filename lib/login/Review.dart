import 'package:cardapio/login/Registro.dart';
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  PageController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = PageController();
    paging();
  }

  paging() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (mounted) {
        if (_controller!.page == 2)
          _controller!.animateToPage(0,
              duration: Duration(milliseconds: 600), curve: Curves.ease);
        else
          _controller!.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        paging();
      }
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/images/breakfast.png"),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Mais agilidade no atendimento",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: size.width * 0.07),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/images/my_app.png"),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Pedido pelo aplicativo direto de casa",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: size.width * 0.07),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/images/smiley.png"),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "E todos satisfeitos",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: size.width * 0.07),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("registro",
                        arguments: RegistroArgs("user"));
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: size.width * 0.9,
                    child: Text(
                      "Prosseguir",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            )
          ],
        ));
  }
}
