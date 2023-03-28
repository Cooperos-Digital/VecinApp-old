import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePag extends StatefulWidget {
  @override
  _HomePagState createState() => _HomePagState();
}

class _HomePagState extends State<HomePag> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("VecinApp"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Se abre el menú.'),
                  )
              );
            },
          )
        ],
      ),

      body: Column(
        children: [
          //topBar()
          //safeArea(
//            child: topBar()
  //        )
          Text("Página principal - Home"),
        ],
      )
    );
  }
}