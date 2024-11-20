import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "673d81b2001562a95dfa";
  static const databaseId = "673d81f80000ff3a840c";
  static const collectionId = "673d820900245f88b4c4";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getEmployee() async {
    try {
      final result = await databases.listDocuments(
          databaseId: databaseId, collectionId: collectionId);
      return result.documents;
    } catch (e) {
      print('Error loading notes:$e');
      rethrow;
    }
  }

  Future<Document> addEmployee(String name, String age, String location) async {
    try {
      final documentId = ID.unique();

      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        data: {
          'name': name,
          'age': age,
          'location': location,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating note:$e');
      rethrow;
    }
  }

  Future<void> deleteEmployee(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting note:$e');
      rethrow;
    }
  }
}
