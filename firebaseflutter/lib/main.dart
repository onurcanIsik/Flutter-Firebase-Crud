// ignore_for_file: unnecessary_this, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseflutter/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseCrud(),
    ),
  );
}

class FirebaseCrud extends StatefulWidget {
  const FirebaseCrud({Key? key}) : super(key: key);

  @override
  State<FirebaseCrud> createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  late String? ad, id, kategori;
  late int? sayfaSayisi;
  idAl(idTutucu) {
    this.id = idTutucu;
  }

  adAl(adTutucu) {
    this.ad = adTutucu;
  }

  katagoriAl(katagoriTutucu) {
    this.kategori = katagoriTutucu;
  }

  sayfaAl(sayfaTutucu) {
    this.sayfaSayisi = int.parse(sayfaTutucu);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Crud"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (String idTutucu) {
                idAl(idTutucu);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kitap Id",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (String adTutucu) {
                adAl(adTutucu);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kitap Adı",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (String katagoriTutucu) {
                katagoriAl(katagoriTutucu);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kitap Katagorisi",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (String sayfaTutucu) {
                sayfaAl(sayfaTutucu);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kitap Sayfası",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  veriEkle();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.green,
                    elevation: 5),
                child: const Text("Ekle"),
              ),
              ElevatedButton(
                onPressed: () {
                  veriOku();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                    shadowColor: Colors.orange,
                    elevation: 5),
                child: const Text("Oku"),
              ),
              ElevatedButton(
                onPressed: () {
                  veriGuncelle();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blue,
                    elevation: 5),
                child: const Text("Güncelle"),
              ),
              ElevatedButton(
                onPressed: () {
                  veriSil();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shadowColor: Colors.red,
                    elevation: 5),
                child: const Text("Sil"),
              ),
            ],
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("kitaplık").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasError) {
                const Text("Aktarım Başarısız");
              } else if (streamSnapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot satirVerisi =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            satirVerisi["kitapId"],
                          ),
                          const Text(" = "),
                          Text(
                            satirVerisi["kitapAd"],
                          ),
                          const Text("   "),
                          Text(
                            satirVerisi["kitapKategori"],
                          ),
                          const Text("   "),
                          Text(
                            satirVerisi["kitapSayfaSayisi"].toString(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  //! Firebase ile ilgili metotlar

  void veriEkle() {
    // Veri yolu ekleme
    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("kitaplık").doc(id);

    // Birden fazla veri ekleme MAP

    Map<String, dynamic> kitaplar = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfaSayisi.toString(),
    };

    //  Veriyi veri tabanına ekleme
    veriYolu.set(kitaplar).whenComplete(() {
      Fluttertoast.showToast(msg: id! + " 'ID li kitap eklendi");
    });
  }

  void veriOku() {
    // Veri yolu

    DocumentReference veriOkumaYolu =
        FirebaseFirestore.instance.collection("kitaplık").doc(id);

    // Veriyi alıcaz

    veriOkumaYolu.get().then((alinanDeger) {
      // Çoklu veriyi alma map ile
      Map<String, dynamic>? alinanVeri =
          alinanDeger.data() as Map<String, dynamic>?;

      //Alınan verideki alanları tutuculara aktar

      String idTutucu = alinanVeri!["kitapId"];
      String adTutucu = alinanVeri["kitapAd"];
      String kategoriTutucu = alinanVeri["kitapKategori"];
      String sayfaTutucu = alinanVeri["kitapSayfaSayisi"];

      //Tutucuları göster

      Fluttertoast.showToast(
          msg: "Id: " +
              idTutucu +
              " Ad: " +
              adTutucu +
              " Kategori: " +
              kategoriTutucu +
              " Sayfa sayısı: " +
              sayfaTutucu);
    });
  }

  void veriGuncelle() {
    DocumentReference veriGuncelleme =
        FirebaseFirestore.instance.collection("kitaplık").doc(id);

    Map<String, dynamic> guncellenecekVeri = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfaSayisi
    };

    veriGuncelleme.update(guncellenecekVeri).whenComplete(() {
      Fluttertoast.showToast(msg: id! + "Id li kitap güncellendi...");
    });
  }

  void veriSil() {
    DocumentReference veriSilme =
        FirebaseFirestore.instance.collection("kitaplık").doc(id);

    veriSilme.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id! + "ID'li data silindi");
    });
  }
}
