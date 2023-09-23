import 'package:socket_io_client/socket_io_client.dart' as IO;

class soc_model {
  IO.Socket socket = IO.io('http://192.168.100.248:5000', <String, dynamic>{
    'transports': ['websocket'],
  });

  var last_data_ekg;

  String data_tempel = 'h';

  void hehe() {
    print('hahaha');
  }

  void start() {
    socket.onConnect((_) {
      socket.emit('ekg');
      socket.emit('ekg_graph');
      print('connect');
    });
  }

  void server_off(name) {
    socket.emit('server_off', {'ev_name': name});
  }

  void kirimData(data_ekg, data_waktu) async {
    while (true) {
      socket
          .emit('save_data', {'data_ekg': data_ekg, 'data_waktu': data_waktu});
      await Future.delayed(Duration(seconds: 5));
      print('data ekg : $data_ekg');
    }
  }
}
