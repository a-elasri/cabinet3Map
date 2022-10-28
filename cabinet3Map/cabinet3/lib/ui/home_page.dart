import 'package:cabinet3/ui/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(70, 20, 0, 0),
                child: Text("3iyadati",style:GoogleFonts.sora(textStyle:TextStyle(fontSize: 40,fontWeight: FontWeight.bold) ))),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: ElevatedButton(onPressed: (){},
                  child: Text("login"),
              style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff3EBDE0))) ,),
            ),
            Image.asset("assets/image/imageHome.jpg"),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ElevatedButton(onPressed: (){
                child:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Splash()),
                );
              },
                child: Text("Trouver un cabinet medical pres de chez vous"),
                style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xff3EBDE0))) ,),
            ),
          ],
        ),
      ),
    );

  }
}