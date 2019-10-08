import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:voteapp/main.dart';
import 'package:voteapp/ui/widgets/custom_flat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrScan extends StatefulWidget {
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
  void arrayQr(String s){
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
  final List<String> codigoqr=codigo;

  print(codigoqr);
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._barcode = barcode);
      arrayQr(_barcode);
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

}