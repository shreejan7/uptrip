// import 'package:flutter/material.dart';
// class BlogImage {
//   const BlogImage({
//     @required this.storagePath,
//     @required this.originalUrl,
//     @required this.bucketName,
//     this.id
//   });

//   final String storagePath;
//   final String originalUrl;
//   final String bucketName;
//   final String id;

//   static String get collectionPath => "blogImages";

//   create() {
//     return Firestore.instance.collection(collectionPath).document().setData({
//       "storagePath" : storagePath,
//       "originalUrl" : originalUrl,
//       "bucketName" : bucketName
//     });
//   }

//   static Future<BlogImage> fromUrl(String url) async {
//     final images = await Firestore.instance.collection(collectionPath)
//       .where("originalUrl", isEqualTo: url)
//       .getDocuments();

//     if (images.documents.isNotEmpty) {
//       final i = images.documents.first.data;

//       return BlogImage(
//         storagePath: i["storagePath"],
//         originalUrl: i["originalUrl"],
//         bucketName: i["bucketName"],
//         id: images.documents.first.documentID
//       );
//     }

//     return null;
//   }

//   Future delete() async {
//     FirebaseStorage.instance.ref().child(storagePath).delete();
//     return Firestore.instance.collection(collectionPath).document(id).delete();
//   }
// }
