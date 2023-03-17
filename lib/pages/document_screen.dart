import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/models/document_model.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/repository/document_repository.dart';
import 'package:google_docs/repository/socket_repository.dart';
import 'package:google_docs/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen(this.id, {super.key});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");

  QuillController? _controller;
  ResponseModel? responseModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) {
      _controller?.compose(
        Delta.fromJson(data['delta']),
        _controller?.selection ?? const TextSelection.collapsed(offset: 0),
        ChangeSource.REMOTE,
      );
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        "delta": _controller!.document.toDelta(),
        "room": widget.id
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    _controller!.dispose();
  }

  void updateDocumentTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateDocumentTitle(widget.id, title);
  }

  void fetchDocumentData() async {
    responseModel =
        await ref.read(documentRepositoryProvider).getDocumentById(widget.id);

    if (responseModel!.data != null) {
      titleController.text = (responseModel!.data as DocumentModel).title;
      _controller = QuillController(
        document: responseModel!.data.content.isEmpty
            ? Document()
            : Document.fromDelta(
                Delta.fromJson(responseModel!.data.content),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }
    _controller!.document.changes.listen((event) {
      // 1 -> entire content of document
      // 2 -> changes that are made from the previous
      // 3-> local - we have typed

      if (event.source == ChangeSource.LOCAL) {
        Map<String, dynamic> map = {"delta": event.change, "room": widget.id};
        socketRepository.typing(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text: 'http://localhost:3000/#/document/${widget.id}'))
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Link copied!',
                      ),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.lock,
                color: kWhiteColor,
              ),
              label: Text("Share"),
              style: ElevatedButton.styleFrom(backgroundColor: kBlueColor),
            ),
          )
        ],
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Routemaster.of(context).replace('/');
              },
              child: Image.asset(
                'assets/images/gdocslogo.png',
                height: 40,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10)),
                onSubmitted: (value) {
                  updateDocumentTitle(ref, value);
                },
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            QuillToolbar.basic(controller: _controller!),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: 750,
                child: Card(
                  color: kWhiteColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: QuillEditor.basic(
                      controller: _controller!,
                      readOnly: false,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
