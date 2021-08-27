import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MainModel.dart';

class MainView extends StatefulWidget {

  var nextPedidos;
  MainView(this.nextPedidos);
  @override
  _MainViewState createState() => _MainViewState(nextPedidos);
}

class _MainViewState extends MainModel {
  _MainViewState(nextPedidos) : super(nextPedidos);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: SingleChildScrollView(child:Container(
        child: Column(children: [
          Container(height: padding.top,color: Colors.orange,width: double.infinity,),
          SizedBox(height: 8,),
          CarouselSlider(
            options: CarouselOptions(autoPlayAnimationDuration: Duration(milliseconds: 800),height: 200.0, autoPlay: true, pauseAutoPlayOnManualNavigate: true, pauseAutoPlayOnTouch: true,
                autoPlayInterval: Duration(seconds: 4),
                enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              viewportFraction: 0.9
            ),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          
                          image: NetworkImage("https://gkpb.com.br/wp-content/uploads/2019/08/cropped-ifood-oferecera-pratos-de-R-1-para-novos-usuarios-geek-publicitario.jpg.png"
                      ),),),

                  ),);
                },
              );
            }).toList(),
          ),

          SizedBox(height: 8,),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Todo seu dia está aqui", style: TextStyle(fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
          Container(
            height: size.width*0.4,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 8, right: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i){
            return CategorySnackItem();
          }, itemCount: 10,),),

          Container(
            padding: EdgeInsets.all(8),
            child: Text("Perto de você", style: TextStyle(fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),

          Column(children: List.generate(18, (index){
            return ShopItem();
          }),)
        ],),
      ),),
    );

  }

  Widget CategorySnackItem(){
    return Container(
      width: size.width*0.3,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image:DecorationImage(image: NetworkImage(
"https://static-images.ifood.com.br/image/upload/t_high,q_100/webapp/landing/landing-banner-1.png",

        ),
      fit: BoxFit.fitHeight,
      ),
    ),),),);
  }

  Widget ShopItem(){
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(1),
      child: Container(
        margin: EdgeInsets.only(left: 4, right: 4),
      height: size.width*0.25,
      child: Row(children: [
        Container(
          margin: EdgeInsets.all(8),
          width: size.width*0.2,
          height: size.width*0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width),
          image: DecorationImage(image: NetworkImage("https://scontent.fqps4-1.fna.fbcdn.net/v/t1.6435-9/47289345_2192462324327619_7533239699356254208_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=Al_R9_rOUZcAX_jV27I&_nc_ht=scontent.fqps4-1.fna&oh=774f7cc9ac72582136e6154b0d4555a6&oe=61491019"),
        ),
          ),
        ),
        Expanded(
          flex: 3,
          child:Container(
          margin: EdgeInsets.only(left: 8),
          alignment: Alignment.centerLeft,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(child:Text("Rei Do Prato", style: TextStyle(fontSize: 18),), alignment: Alignment.centerLeft),
              Container(child:Text("40 - 120 min", textAlign: TextAlign.left, style: TextStyle(fontSize: 14, color: Colors.green[800])), alignment: Alignment.centerLeft,),
          ],),),
        ),
        Expanded(
            flex: 1,
            child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Icon(Icons.location_pin, color: Colors.red,),
          Text("1.3km")
        ],)),
      ],),
    ),);
  }

}
