// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_scanner_card_app/pages/latest_documents_page.dart';

import '../data/datasources/document_local_datasource.dart';
import '../data/models/document_model.dart';

class DocumentCategoryPage extends StatefulWidget {
  final String categoryTitle;
  const DocumentCategoryPage({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<DocumentCategoryPage> createState() => _DocumentCategoryPageState();
}

class _DocumentCategoryPageState extends State<DocumentCategoryPage> {
  List<DocumentModel> documents = [];

  loadData() async {
    documents = await DocumentLocalDatasource.instance
        .getDocumentByCategory(widget.categoryTitle);
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
        title: Text('Document ${widget.categoryTitle}'),
      ),
      body: Column(
        children: [
          Expanded(
              child: LatestDocumentsPage(
            documents: documents,
          )),
        ],
      ),
    );
  }
}
