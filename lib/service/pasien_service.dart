import 'package:dio/dio.dart';

import '../helpers/api_client.dart';
import '../model/pasien.dart';

class PasienService {
  Future<List<Pasien>> listData() async {
    final Response response = await ApiClient().get('pasien');
    final List data = response.data as List;
    List<Pasien> result = data.map((json) => Pasien.fromJson(json)).toList();
    return result;
  }

  Future<Pasien> simpan(Pasien pasien) async {
    var data = pasien.toJson();
    final Response response = await ApiClient().post('pasien', data);
    Pasien result = Pasien.fromJson(response.data);
    return result;
  }

  Future<Pasien> ubah(Pasien pasien, String id) async {
    var data = pasien.toJson();
    final Response response = await ApiClient().put('pasien/$id', data);
    Pasien result = Pasien.fromJson(response.data);
    return result;
  }

  Future<Pasien> getById(String id) async {
    final Response response = await ApiClient().get('pasien/$id');
    Pasien result = Pasien.fromJson(response.data);
    return result;
  }

  // json-server membalas DELETE dengan body kosong, jadi hasilnya tidak diparse.
  Future<void> hapus(Pasien pasien) async {
    await ApiClient().delete('pasien/${pasien.id}');
  }
}
