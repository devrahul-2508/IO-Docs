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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();

    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
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
  Widget build(BuildContext context,WidgetRef ref) {
    print("Build method called");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  createDocument(context, ref);
                },
                icon: Icon(
                  Icons.add,
                  color: kBlackColor,
                )),
            IconButton(
                onPressed: () {
                  signOut(ref);
                },
                icon: Icon(
                  Icons.logout,
                  color: kRedColor,
                ))
          ],
        ),
        body: FutureBuilder<ResponseModel?>(
            future: ref.read(documentRepositoryProvider).getDocuments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else {
                ApiResponseDocumentModels apiResponseDocumentModels =
                    (snapshot.data!.data as ApiResponseDocumentModels);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      itemCount: apiResponseDocumentModels.documents.length,
                      itemBuilder: (context, index) {
                        DocumentModel document =
                            apiResponseDocumentModels.documents[index];

                        return InkWell(
                          onTap: (() {
                            navigateToDocument(context, document.id);
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
