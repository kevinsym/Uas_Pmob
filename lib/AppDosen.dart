import 'package:flutter/material.dart';
import 'package:uas_pmob/dosen.dart';
import 'dosen.dart';
import 'Services.dart';
import 'dart:async';

class AppDosen extends StatefulWidget{
  AppDosen() : super();

  final String title = "UAS Pemrograman Mobile";

  @override
  AppDosenState createState() => AppDosenState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class AppDosenState extends State<AppDosen>{
  List<Dosen> _dosenn;
  List<Dosen> _filterDosen;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nisnDosenController;
  TextEditingController _namaDosenController;
  Dosen _selectedDosen;
  bool _isUpdating;
  String _titleProgress;

  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _dosenn = [];
    _filterDosen = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _nisnDosenController = TextEditingController();
    _namaDosenController = TextEditingController();
    _getDosen();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {

        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }


  _addDosen() {
    if (_nisnDosenController.text.isEmpty || _namaDosenController.text.isEmpty) {
      print('Fields Kosong');
      return;
    }
    _showProgress('Menambahkan Dosen...');
    Services.addDosen(_nisnDosenController.text, _namaDosenController.text)
        .then((result) {
      if ('success' == result) {
        _getDosen();
        _clearValues();
      }
    });
  }

  _getDosen() {
    _showProgress('Loading Dosen...');
    Services.getDosen().then((dosenn) {
      setState(() {
        _dosenn = dosenn;
      });
      _showProgress(widget.title);
      print("Length ${dosenn.length}");
    });
  }

  _updateDosen(Dosen dosen) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Mengupdate Dosen...');
    Services.updateDosen(
        dosen.id, _nisnDosenController.text, _namaDosenController.text)
        .then((result) {
      if ('success' == result) {
        _getDosen();
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteDosen(Dosen dosen) {
    _showProgress('Menghapus Dosen...');
    Services.deleteDosen(dosen.id).then((result) {
      if ('success' == result) {
        _getDosen();
      }
    });
  }


  _clearValues() {
    _nisnDosenController.text = '';
    _namaDosenController.text = '';
  }

  _showValues(Dosen dosen) {
    _nisnDosenController.text = dosen.nidn_dosen;
    _namaDosenController.text = dosen.nama_dosen;
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('NIDN DOSEN'),
            ),
            DataColumn(
              label: Text('NAMA DOSEN'),
            ),
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _filterDosen.map(
                (dosen) => DataRow(cells: [
              DataCell(
                Text(dosen.id),
                onTap: () {
                  _showValues(dosen);

                  _selectedDosen = dosen;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  dosen.nidn_dosen.toUpperCase()),
                onTap: () {
                  _showValues(dosen);

                  _selectedDosen = dosen;

                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  dosen.nama_dosen.toUpperCase(),
                ),
                onTap: () {
                  _showValues(dosen);

                  _selectedDosen = dosen;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteDosen(dosen);
                },
              ))
            ]),
          )
              .toList(),
        ),
      ),
    );
  }

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter by NIDN atau Nama Dosen',
        ),
        onChanged: (string) {
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filterDosen = _dosenn
                  .where((u) => (u.nidn_dosen
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.nama_dosen.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getDosen();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.green,
                  ],
                ),

              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(

                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage('assets/profilepict.jpg'),
                    ),
                  ),
                  Text('Kevin Semuel Yuri Mulyadi'),
                  Text('20190801052'),
                ],
              ),
            ),
            Text('''
UAS
Pemograman Mobile
CRUD DATA DOSEN''',
              textAlign: TextAlign.center,),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _nisnDosenController,
                decoration: InputDecoration.collapsed(
                  hintText: 'NISN Dosen',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _namaDosenController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Nama Dosen',
                ),
              ),
            ),
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateDosen(_selectedDosen);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            searchField(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addDosen();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}