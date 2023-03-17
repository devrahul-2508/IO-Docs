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
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void signOut() {
    ref.read(authRepositoryProvider).signOut();

    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context) async {
    final ResponseModel response =
        await ref.read(documentRepositoryProvider).createDocument();

    if (response.data != null) {
      Routemaster.of(context).push("/document/${response.data.id}");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called");
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
        body: FutureBuilder<ApiResponseDocumentModels?>(
            future: ref.read(documentRepositoryProvider).getDocuments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else {
                // ApiResponseDocumentModels apiResponseDocumentModels =
                //     (snapshot.data!.data as ApiResponseDocumentModels);

                if (snapshot.data == null) {
                  return const Loader();
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      itemCount: snapshot.data!.documents.length,
                      itemBuilder: (context, index) {
                        DocumentModel document =
                            snapshot.data!.documents[index];

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
                );
              }
            }));
  }
}
