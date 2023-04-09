import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/models/api_response_document_model.dart';
import 'package:google_docs/models/document_model.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:google_docs/repository/document_repository.dart';
import 'package:google_docs/widgets/loader.dart';
import 'package:google_docs/widgets/responsive_widget.dart';
import 'package:routemaster/routemaster.dart';

final documentProvider =
    StateNotifierProvider<DocumentNotifier, List<DocumentModel>>(
        (ref) => DocumentNotifier([]));

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDocuments();
  }

  void fetchDocuments() async {
    ResponseModel responseModel =
        await ref.read(documentRepositoryProvider).getDocuments("");

    if (responseModel.success) {
      ref.read(documentProvider.notifier).state = responseModel.data.documents;
    }
  }

  void signOut() {
    ref.read(authRepositoryProvider).signOut();

    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context) async {
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final ResponseModel response =
        await ref.read(documentRepositoryProvider).createDocument();

    if (response.data != null) {
      navigator.push("/document/${response.data.id}");
      Future.delayed(Duration(seconds: 1));
      ref.read(documentProvider.notifier).addDocument(response.data);
    } else {
      snackbar.showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) async {
    Routemaster.of(context).push('/document/$documentId');
  }

  void searchDocument(String query) async {
    ResponseModel responseModel =
        await ref.read(documentRepositoryProvider).getDocuments(query);

    if (responseModel.success) {
      ref.read(documentProvider.notifier).state = responseModel.data.documents;
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  createDocument(context);
                },
                icon: Icon(
                  Icons.add,
                  color: kBlackColor,
                )),
            IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(
                  Icons.logout,
                  color: kRedColor,
                ))
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.036),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search for documents",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (value) {
                  searchDocument(value);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            ResponsiveWidget.isSmallScreen(context)
                                ? 800
                                : (ResponsiveWidget.isMediumScreen(context)
                                    ? 400
                                    : 300),
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      DocumentModel document = documents[index];

                      return InkWell(
                        onTap: (() {
                          navigateToDocument(context, document.id);
                          // setState(() {

                          // });
                        }),
                        child: Card(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                document.title,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
