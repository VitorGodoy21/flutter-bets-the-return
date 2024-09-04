import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseManagement{

  //Function to create new column using data from another column
  Future<void> updateDocuments() async {
    //collection name to create a column
    const String collectionName = 'bets';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    const int batchSize = 700; // Número de documentos a serem atualizados por vez

    Query query = firestore.collection(collectionName);
    QuerySnapshot querySnapshot = await query.get();

    while (querySnapshot.docs.isNotEmpty) {
      WriteBatch batch = firestore.batch();
      int count = 0;

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Adicionar a nova coluna com base nas informações da coluna existente
        Timestamp? tipTimestamp = data["tip_date"].toTimestamp("dd/MM/yyyy");
        Timestamp? eventTimestamp = data["event_date"].toTimestamp("dd/MM/yyyy");
        DocumentReference docRef = firestore.collection(collectionName).doc(docSnapshot.id);

        //create column using created data
        batch.update(docRef, {'tip_date_timestamp': tipTimestamp, 'event_date_timestamp':eventTimestamp});

        count++;
        if (count >= batchSize) {
          break;
        }
      }

      await batch.commit();
      print('Lote de documentos atualizado.');

      // Obter o próximo lote de documentos
      DocumentSnapshot lastVisible = querySnapshot.docs.last;
      query = query.orderBy(FieldPath.documentId).startAfterDocument(lastVisible);
      querySnapshot = await query.get();
    }

    print('Todos os documentos foram atualizados.');
  }

  Timestamp? stringToTimestamp(String dateString, String dateFormatString) {
    try {
      // Define o formato da data
      DateFormat dateFormat = DateFormat(dateFormatString);

      // Converte a string para um objeto DateTime
      DateTime dateTime = dateFormat.parse(dateString);

      // Converte DateTime para Timestamp
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      return timestamp;
    } catch (e) {
      print('Erro ao converter data: $e');
      return null;
    }
  }
}