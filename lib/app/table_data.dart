import 'package:features/app/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'appdata.dart';
import 'package:path_provider/path_provider.dart';

class TableData extends StatefulWidget implements PreferredSizeWidget {
  final double _height = 56.0;

  @override
  Size get preferredSize => Size.fromHeight(_height);

  final List<AppData> appdata;

  final String title;

  const TableData({Key? key, required this.appdata, required this.title})
      : super(key: key);

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TextEditingController _searchTextController;

  late List<AppData> _filteredDataList;
  final int _currentPage = 0;
  final int rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchTextController = TextEditingController();
    _filteredDataList = widget.appdata;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    debugPrint('Location:: ${statuses[Permission.location].toString()}');
    debugPrint('Storage:: ${statuses[Permission.storage].toString()}');
  }

  List<AppData> _getTableData() {
    List<AppData> filteredData = widget.appdata.where((data) {
      return data.name
          .toLowerCase()
          .contains(_searchTextController.text.toLowerCase());
    }).toList();

    int startIndex = _currentPage * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    endIndex = endIndex > filteredData.length ? filteredData.length : endIndex;

    List<AppData> pageData = filteredData.sublist(startIndex, endIndex);

    return pageData;
  }

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text(widget.title),
        actions: _buildAppBarActions(),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final file = await generatePdf(widget.appdata);

            final String filePath = file.absolute.path;
            final Uri uri = Uri.file(filePath);

            Fluttertoast.showToast(
              msg: "PDF is downloaded successfully to '$filePath'",
              toastLength: Toast.LENGTH_LONG,
            );
            debugPrint(file.toString());
            debugPrint(filePath);
            debugPrint(uri.toString());

            if (await file.exists()) {
              gotoNext(filePath);
            } else {
              debugPrint("File does not exist!");
            }
          },
          child: const Icon(Icons.picture_as_pdf)),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          // header: const Text('App Data'),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Gender')),
            DataColumn(label: Text('DOB')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Address')),
          ],
          source: _AppDataSource(
            filteredDataList: _filteredDataList,
            rowsPerPage: rowsPerPage,
            currentPage: _currentPage,
            // context: context,
          ),
          onPageChanged: (value) {
            setState(() {
              _getTableData();
            });
          },
          rowsPerPage: rowsPerPage,
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchTextController.clear();
            setState(() {
              _isSearching = false;
              _filteredDataList = widget.appdata;
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      autofocus: true,
      focusNode: FocusNode(),
      onChanged: (value) {
        setState(() {
          _filteredDataList = widget.appdata
              .where((data) =>
                  data.name.toLowerCase().contains(value.toLowerCase()) ||
                  data.gender.toLowerCase().contains(value.toLowerCase()) ||
                  data.dob.toLowerCase().contains(value.toLowerCase()) ||
                  data.phone.toLowerCase().contains(value.toLowerCase()) ||
                  data.address.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  void gotoNext(String filePath) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PdfViewer(filePath)));
  }

  Future<File> generatePdf(List<AppData> dataList) async {
    final pdf = pw.Document();

    final ByteData fontData =
        await rootBundle.load('assets/Caveat-Regular.ttf');

    final ttf = pw.Font.ttf(ByteData.view(fontData.buffer));

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Add a header to the page
              pw.Text('App Data', style: pw.TextStyle(fontSize: 20, font: ttf)),
              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['Name', 'Gender', 'DOB', 'Phone', 'Address'],
                  ...dataList.map((data) => [
                        data.name,
                        data.gender,
                        data.dob,
                        data.phone,
                        data.address
                      ]),
                ],
              ),
            ],
          );
        }));

    final String? downloadDir = await getDownloadPath();
    final file = File("$downloadDir/appData.pdf");
    await file.writeAsBytes(await pdf.save());

    debugPrint('Saved at: $file');

    return file;
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      debugPrint("Cannot get download folder path");
      debugPrint(err.toString());
      debugPrint(stack.toString());
    }
    return directory?.path;
  }
}

class _AppDataSource extends DataTableSource {
  final List<AppData> filteredDataList;
  final int currentPage;
  final int rowsPerPage;

  _AppDataSource({
    required this.filteredDataList,
    required this.currentPage,
    required this.rowsPerPage,
  });

  @override
  DataRow? getRow(int index) {
    final data = filteredDataList[currentPage * rowsPerPage + index];
    return DataRow(cells: [
      DataCell(Text(data.name)),
      DataCell(Text(data.gender)),
      DataCell(Text(data.dob)),
      DataCell(Text(data.phone)),
      DataCell(Text(data.address)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredDataList.length;

  @override
  int get selectedRowCount => 0;
}
