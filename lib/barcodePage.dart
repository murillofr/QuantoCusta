import 'package:flutter/material.dart';

class BarcodePage extends StatefulWidget {
  final String resultBarcode;
  final String inOutScan;

  const BarcodePage({Key key, this.resultBarcode, this.inOutScan})
      : super(key: key);

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

const List<String> _photoData = const [
  "assets/bing.png",
  "assets/google.png",
  "assets/youtube.jpg",
];

class _BarcodePageState extends State<BarcodePage> {
  @override
  void initState() {
    print(widget.resultBarcode);
    print(widget.inOutScan);
    print(_coverPhoto);
    super.initState();
    print(widget.resultBarcode);
    print(widget.inOutScan);
    print(_coverPhoto);
  }

  int _coverPhoto = 0;

  void didUpdateWidget(BarcodePage oldWidget) {
    if (oldWidget.inOutScan == 'in' && widget.inOutScan == 'out') {
      print('------------------IF------------------');
      _switchCoverPhoto();
    } else {
      print('------------------ELSE------------------');
    }
    super.didUpdateWidget(oldWidget);
  }

  void _switchCoverPhoto() {
    setState(() {
      _coverPhoto++;
      if (_coverPhoto == _photoData.length) {
        _coverPhoto = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 200,
                            color: Colors.white,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Visibility(
                                  visible: widget.resultBarcode == '',
                                  child: Container(
                                    child: Text('LOGO DO APP'),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.resultBarcode != '',
                                  child: Flexible(
                                    child: Image(
                                      image:
                                          AssetImage(_photoData[_coverPhoto]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter a search term'),
                          ),
                          Text('data 1'),
                          Text('data 2'),
                          Text('data 3'),
                          Text('data 4'),
                          Text('data 5'),
                          Text('data 6'),
                          Text('data 7'),
                          Text('data 8'),
                          Text('data 9'),
                          Text('data 10'),
                          Text('data 11'),
                          Text('data 12'),
                          Text('data 13'),
                          Text('data 14'),
                          Text('data 15'),
                          Text('data 16'),
                          Text('data 17'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: widget.resultBarcode == '' ? 0 : null,
                  margin: EdgeInsets.only(top: 178.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow[200],
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      color: Colors.yellow[200],
                    ),
                    child: Text(
                      widget.resultBarcode,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
