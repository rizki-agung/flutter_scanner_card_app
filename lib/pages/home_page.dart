import 'package:flutter/material.dart';
import 'package:flutter_scanner_card_app/core/title_content.dart';
import 'package:flutter_scanner_card_app/data/models/document_model.dart';
import 'package:flutter_scanner_card_app/pages/latest_documents_page.dart';
import 'package:flutter_scanner_card_app/pages/save_document_page.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

import '../core/colors.dart';
import '../core/spaces.dart';
import '../data/datasources/document_local_datasource.dart';
import 'menu_categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentModel> documents = [];

  String? pathImage;

  loadData() async {
    documents = await DocumentLocalDatasource.instance.getAllDocuments();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Scanner'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Place Document to be Scanned',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceHeight(8.0),
                ElevatedButton(
                    onPressed: () async {
                      DocumentScannerOptions documentOptions =
                          DocumentScannerOptions(
                        documentFormat: DocumentFormat.jpeg,
                        mode: ScannerMode.filter,
                        pageLimit: 1,
                        isGalleryImport: true,
                      );

                      final documentScanner =
                          DocumentScanner(options: documentOptions);

                      DocumentScanningResult result =
                          await documentScanner.scanDocument();

                      final pdf = result.pdf;
                      final images = result.images;

                      // log('PDF: $pdf');
                      // log('Images: $images');
                      pathImage = images[0];

                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SaveDocumentPage(pathImage: pathImage!)));
                      loadData();
                    },
                    child: const Text('Scan Document')),
              ],
            ),
          ),
          const SpaceHeight(16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TitleContent(
              title: 'Categories',
              onSeeAllTap: () {},
            ),
          ),
          const SpaceHeight(12.0),
          const MenuCategories(),
          const SpaceHeight(12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TitleContent(
              title: 'Latest Documents',
              onSeeAllTap: () {},
            ),
          ),
          const SpaceHeight(12.0),
          Expanded(child: LatestDocumentsPage(documents: documents)),
        ],
      ),
    );
  }
}
