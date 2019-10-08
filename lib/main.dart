import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:voteapp/qr_scan.dart';
import 'package:voteapp/ui/widgets/custom_flat_button.dart';
import 'package:voteapp/ui/screens/walk_screen.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //print(codi);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
//clase para guardar valores del qr


class _MyHomePageState extends State<MyHomePage> {
  String texti="";       List<String>partidoArray=["0","0","0","0","0","0","0","0","0","0","0"];List<String>votosArray=["0","0","0","0","0","0","0","0","0","0","0"];


 void _awaitReturnValueFromSecondScreen(BuildContext context)async{
  final  result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => QrScan(),
    ));
    setState(() {
     texti=result; 
    });
 }

   File pickedImage;  final databaseReference = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  bool isImageLoaded = false;

  Future pickImage() async {


    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
     BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector(BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue);
    }


    List<String>partidos=["CC","FPV","MTS","UCS","MAS-IPSP","BDN","21F","PDC","MNR","PAN-BOL","BLANCO","NULO","NOLO"];
            int j=0; int k=0;

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          
        final value = word.text;
        final newValue = value.replaceAll("-", "").replaceAll("=", "");
        
         if (partidos.contains(word.text)) {
          partidoArray.insert(k,partidoN(word.text));
          k++;
         }
         if (isNumeric(newValue)) {
          votosArray.insert(j,newValue); 
          j++;          
         } 
        }
      }
    }
    while(partidoArray.length<11){
    partidoArray.add("0");
  }
   while(votosArray.length<11){
    votosArray.add("0");
  }
 
    insertdato(texti); 
    //updateV(texti, partidoArray, votosArray);
  }
  bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}
String partidoN(String p){
  List<String>cc=["cc","CC"];
  if (cc.contains(p)){return "1";}
  List<String>fpv=["fpv","FPV"];
  if (fpv.contains(p)){return "2";}
  List<String>mts=["mts","MTS"];
  if (mts.contains(p)){return "3";}
  List<String>ucs=["ucs","UCS"];
  if (ucs.contains(p)){return "4";}
  List<String>mas=["mas","MAS","MAS-IPSP"];
  if (mas.contains(p)){return "5";}
  List<String>bdn=["bdn","BDN","21F"];
  if (bdn.contains(p)){return "6";}
  List<String>pdc=["pdc","PDC"];
  if (pdc.contains(p)){return "7";}
  List<String>mnr=["MNR","mnr"];
  if (mnr.contains(p)){return "8";}
  List<String>panbol=["pan-bol","PAN-BOL"];
  if (panbol.contains(p)){return "9";}
  List<String>blanco=["blanco","BLANCO"];
  if (blanco.contains(p)){return "91";}
  List<String>nulo=["nulo","NULO","NOLO"];
  if (nulo.contains(p)){return "92";}
  return "";
}
 void arrayQr(String x){
   String s=texti;
      List<String>codigo=[];  String cad="";

  for (var i = 0; i < s.length; i++) {
    if(s[i]!="-"){
      cad=cad+s[i];
    }else{
      codigo.add(cad);
      cad="";
    }
  }
  

  }


void insertdato (String s) async {
  
      List<String>codigo=[];  String cad="";
  for (var i = 0; i < s.length; i++) {
    if(s[i]!="-"){
      cad=cad+s[i];
    }else{
      codigo.add(cad);
      cad="";
    }
  }
 
  codigo.add(cad);

  await databaseReference.collection('partidos').document(partidoArray[0]).updateData({'votos':votosArray[0]});
  await databaseReference.collection('partidos').document(partidoArray[1]).updateData({'votos':votosArray[1]});
  await databaseReference.collection('partidos').document(partidoArray[2]).updateData({'votos':votosArray[2]});
  await databaseReference.collection('partidos').document(partidoArray[3]).updateData({'votos':votosArray[3]});
  await databaseReference.collection('partidos').document(partidoArray[4]).updateData({'votos':votosArray[4]});
  await databaseReference.collection('partidos').document(partidoArray[5]).updateData({'votos':votosArray[5]});
  await databaseReference.collection('partidos').document(partidoArray[6]).updateData({'votos':votosArray[6]});
  await databaseReference.collection('partidos').document(partidoArray[7]).updateData({'votos':votosArray[7]});
  await databaseReference.collection('partidos').document(partidoArray[8]).updateData({'votos':votosArray[8]});
  await databaseReference.collection('partidos').document(partidoArray[9]).updateData({'votos':votosArray[9]});
  await databaseReference.collection('partidos').document(partidoArray[10]).updateData({'votos':votosArray[10]});
  await databaseReference.collection('partidos').document(partidoArray[11]).updateData({'votos':votosArray[11]});

   await 
  databaseReference .collection (partidoArray[0]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[0]
  });
  await 
  databaseReference .collection (partidoArray[1]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[1]
  });
  await 
  databaseReference .collection (partidoArray[2]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[2]
  });
 
  await 
  databaseReference .collection (partidoArray[3]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[3]
  });
  await 
  databaseReference .collection (partidoArray[4]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[4]
  });
  await 
  databaseReference .collection (partidoArray[5]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[5]
  });
  await 
  databaseReference .collection (partidoArray[6]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[6]
  });
  await 
  databaseReference .collection (partidoArray[7]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[7]
  });
  await 
  databaseReference .collection (partidoArray[8]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[8]
  });
   await 
  databaseReference .collection (partidoArray[9]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[9]
  }); await 
  databaseReference .collection (partidoArray[10]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[10]
  });
   await 
  databaseReference .collection (partidoArray[11]).add({
    'departamento': codigo[0],
    'localidad':codigo[1],
    'recinto': codigo[2],
    'mesa':codigo[3],
    'votos':votosArray[11]
  });
  

}
//PRUEBA PA ELECCIONES TOTALES
void updateData(String p,String v) {
  
    try {
      databaseReference
          .collection('partidos')
          .document(p)
          .updateData({'votos': v});
    } catch (e) {
      print(e.toString());
    }
  }
  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text("Vote App"),
        centerTitle: true,
      ),
    body: Column(
      children: <Widget>[
        SizedBox(height: 100.0),
        isImageLoaded
            ? Center(
                child: Container(
                    height: 300.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover))),
              )
            : Container(),
        SizedBox(height: 10.0),
        //  Padding(
        //       padding: const EdgeInsets.all(32.0),
        //       child: Text(
        //         texti,
        //         style: TextStyle(fontSize: 24),
        //       ),
        //     ),

     
        Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "Scanner QR",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {
                                    _awaitReturnValueFromSecondScreen(context);

                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.lightBlue,
                  borderWidth: 2,
                  color: Color.fromRGBO(51, 153, 255, 1.0),
                ),
              ),
              
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "Abrir Galeria",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {pickImage();
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.lightBlue,
                  borderWidth: 2,
                  color: Color.fromRGBO(51, 153, 255, 1.0),
                ),
              ),
         Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "Scanear Votos",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () { readText();
           
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.lightBlue,
                  borderWidth: 2,
                  color: Color.fromRGBO(51, 153, 255, 1.0),
                ),
              ),
         
       
      ],
    ),      
    drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new Container (
              
            height: 250,
            decoration: new BoxDecoration (
                color: Colors.blue
                
                
            ),
            
            child: new Icon (
                Icons.account_circle,
                size: 225.0,
                color: Colors.white,

            )
        ),
            
            ListTile(
                    leading: Icon(Icons.menu,),
                    title: Text('Menú'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
            
            ListTile(
              leading: Icon(Icons.library_books,),
              title: Text('Manual'),
              onTap: () {
              Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new WalkthroughScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,),
              title: Text('Salir'),
              onTap: () {                     
                 Navigator.of(context).pop();
            //onPressed: ()=> exit(0),

              },
            )
          ],
        ),
      ),
     
    );
    
  }
  
}

/////qr
///
///
class QrScan extends StatefulWidget {
  String codex;
  @override 
  State<StatefulWidget> createState() {
    return QrScanState();
  }
}

class QrScanState extends State<QrScan> {
  String _barcode = "";  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lector QR flutter'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/barcode.png',
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
               Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10.0),
                      child: CustomFlatButton(
                  title: "Scanear el código QR",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {scan(); 
                  },
                  

                  splashColor: Colors.black12,
                  borderColor: Colors.lightBlue,
                  borderWidth: 2,
                  color: Color.fromRGBO(51, 153, 255, 1.0),
                )
                    ),
               Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10.0),
                      child: CustomFlatButton(
                  title: "Enviar codigo QR",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {_sendDataBack(context); 
                  },
                  

                  splashColor: Colors.black12,
                  borderColor: Colors.lightBlue,
                  borderWidth: 2,
                  color: Color.fromRGBO(51, 153, 255, 1.0),
                )
                    ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        _barcode,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ],
          ),
        ));
  }
 
  
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._barcode = barcode); 

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._barcode = 'El usuario no dio permiso para el uso de la cámara!';
        });
      } else {
        setState(() => this._barcode = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._barcode = 'Error desconocido : $e');
    }
  }
void _sendDataBack(BuildContext context) {
    String textToSendBack = _barcode;
    Navigator.pop(context, textToSendBack);
  }
}