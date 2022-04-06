import 'package:http/http.dart' as http;

class SendFiles {
  Future<void> sendFiles(List<String> filePaths) async {

    print(filePaths);

    String url = '';
    var headers = {
      'Content-Type': 'application/json, charset=UTF-8',
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filePaths.first));
    request.files.add(await http.MultipartFile.fromPath('image', filePaths.last));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      print('success');
    } else {
      print('failed');
    }
  }
}
