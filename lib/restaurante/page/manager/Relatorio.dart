import 'package:cardapio/api/controller/RelatorioController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  List<charts.Series<Cat, String>> bars = [];
  List<charts.Series<Cat, String>> mensalBars = [];
  List<charts.Series<Cat, String>> pie = [];
  RelatorioController controller = RelatorioController();
  var title = "HOJE";
  var totalPedidos = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    Future.delayed(Duration(milliseconds: 100), () {
      init("");
      mensal();
    });
  }

  init(date) async {
    try {
      var result = await controller.loadRelatorio(date);

      List<Cat> dataPie = [];

      pie.add(new charts.Series<Cat, String>(
        domainLowerBoundFn: (datum, index) => datum.cat,
        id: 'Categorias',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Cat cat, _) => cat.cat,
        measureFn: (Cat cat, _) => cat.qtd,
        data: dataPie,
        labelAccessorFn: (Cat cat, a) => cat.cat,
        outsideLabelStyleAccessorFn: (datum, index) =>
            charts.TextStyleSpec(color: charts.MaterialPalette.black),
      ));
      if (result != null) {
        var porProdutos = result['porprodutos'];
        List<Cat> data = [];
        for (var cat in porProdutos) {
          data.add(Cat(cat['nome'], cat['count']));
        }
        setState(() {
          totalPedidos = result['pedidos'];
        });
        setState(() {
          bars = [
            charts.Series<Cat, String>(
              domainLowerBoundFn: (datum, index) => datum.cat,
              id: 'Pedidos',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (Cat cat, _) => cat.cat,
              measureFn: (Cat cat, _) => cat.qtd,
              data: data,
              labelAccessorFn: (Cat cat, a) => cat.qtd.toString(),
              outsideLabelStyleAccessorFn: (datum, index) =>
                  charts.TextStyleSpec(color: charts.MaterialPalette.black),
            )
          ];
        });

        var porCategoria = result['porcategoria'];
        List<Cat> datac = [];
        for (var cat in porCategoria) {
          datac.add(Cat(cat['nome'], cat['count']));
        }
        setState(() {
          pie = [
            charts.Series<Cat, String>(
              domainLowerBoundFn: (datum, index) => datum.cat,
              id: 'Categorias',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (Cat cat, _) => cat.cat,
              measureFn: (Cat cat, _) => cat.qtd,
              data: datac,
              labelAccessorFn: (Cat cat, a) => cat.cat,
              outsideLabelStyleAccessorFn: (datum, index) =>
                  charts.TextStyleSpec(color: charts.MaterialPalette.black),
            )
          ];
        });
      }
    } catch (e) {}
  }

  mensal() async {
    try {
      var result = await controller.loadRelatorioMensal();
      if (result != null) {
        List<Cat> datac = [];
        for (var cat in result) {
          datac.add(Cat(cat['nome'], cat['qtd']));
        }
        setState(() {
          mensalBars = [
            charts.Series<Cat, String>(
              domainLowerBoundFn: (datum, index) => datum.cat,
              id: 'Categorias',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (Cat cat, _) => cat.cat,
              measureFn: (Cat cat, _) => cat.qtd,
              data: datac,
              labelAccessorFn: (Cat cat, a) => cat.qtd.toString(),
              outsideLabelStyleAccessorFn: (datum, index) =>
                  charts.TextStyleSpec(color: charts.MaterialPalette.black),
            )
          ];
        });
      } else
        mensalBars = [];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: SizedBox(),
        leadingWidth: 0,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("HOJE"),
                            onTap: () {
                              title = "HOJE";
                              Navigator.pop(context);
                              init("");
                            },
                          ),
                          ListTile(
                            title: Text("ONTEM"),
                            onTap: () {
                              title = "ONTEM";
                              Navigator.pop(context);
                              init("ontem");
                            },
                          ),
                          ListTile(
                            title: Text("SEMANA"),
                            onTap: () {
                              title = "SEMANA";
                              Navigator.pop(context);
                              init("semana");
                            },
                          ),
                          ListTile(
                            title: Text("MÊS"),
                            onTap: () {
                              title = "MÊS";
                              Navigator.pop(context);
                              init("mes");
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          ListTile(
            title: Text("TOTAL PEDIDOS $totalPedidos"),
          ),
          Row(
            children: [
              Container(
                width: size.width * 0.6,
                child: Center(child: Text("Produtos")),
              ),
              Container(
                width: size.width * 0.4,
                child: Center(child: Text("Categorias")),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                height: size.height * 0.6,
                width: size.width * 0.6,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: charts.BarChart(
                      bars,
                      animate: true,
                      defaultRenderer: charts.BarRendererConfig(
                        barRendererDecorator: charts.BarLabelDecorator(
                            labelPosition: charts.BarLabelPosition.outside),
                      ),
                    ),
                  ),
                ),
              ),

              /*
              CICLE
              */

              Container(
                padding: EdgeInsets.all(4),
                height: size.height * 0.6,
                width: size.width * 0.4,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: charts.PieChart(
                      pie,
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator()
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text("ÚLTIMOS 30 DIAS"),
          ),
          Container(
            margin: EdgeInsets.all(4),
            height: size.height * 0.8,
            width: size.width,
            child: Card(
              child: Container(
                padding: EdgeInsets.all(8),
                child: charts.BarChart(
                  mensalBars,
                  animate: true,
                  defaultRenderer: charts.BarRendererConfig(
                    barRendererDecorator: charts.BarLabelDecorator(
                        labelPosition: charts.BarLabelPosition.outside),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Cat {
  var qtd;
  var cat;
  Cat(this.cat, this.qtd);
}
