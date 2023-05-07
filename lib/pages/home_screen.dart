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

import '../constants.dart';

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
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.isLargeScreen(context)
                      ? width * 0.25
                      : width * 0.036),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffbf1f3f4),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search for documents",
                      border: InputBorder.none),
                  onChanged: (value) {
                    searchDocument(value);
                  },
                ),
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
                    itemCount: documents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: (() {}),
                          child: Card(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(
                                child: Image.asset(
                              "assets/images/gadd.png",
                              height: 100,
                            )),
                          ),
                        );
                      }
                      DocumentModel document = documents[index - 1];

                      return InkWell(
                        onTap: (() {
                          navigateToDocument(context, document.id);
                          // setState(() {

                          // });
                        }),
                        child: Card(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        ResponsiveWidget.isLargeScreen(context)
                                            ? 50
                                            : ResponsiveWidget.isMediumScreen(
                                                    context)
                                                ? 70
                                                : 120,
                                        0,
                                        ResponsiveWidget.isLargeScreen(context)
                                            ? 50
                                            : ResponsiveWidget.isMediumScreen(
                                                    context)
                                                ? 50
                                                : 80),
                                    child: Text(
                                      document.title,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                Expanded(
                                    child: Container(
                                  color: Color(0xffbf1f3f4),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Image.asset(
                                        "assets/images/gdocslogo.png",
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "created on ${Constants.formatDate(document.createdAt!)}")
                                    ],
                                  ),
                                ))
                              ],
                            )),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
