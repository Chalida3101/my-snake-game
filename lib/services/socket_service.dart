import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connectSocket(String username) {
    socket = IO.io(
      'http://10.29.168.79:3000', // 👈 เปลี่ยน <IPเครื่องเซิร์ฟเวอร์> เป็นไอพีจริงของเครื่องที่รัน Node.js
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    // เชื่อมต่อ
    socket.connect();

    // เมื่อเชื่อมต่อสำเร็จ
    socket.onConnect((_) {
      print('✅ เชื่อมต่อกับเซิร์ฟเวอร์แล้ว');
      socket.emit('join_game', username); // ส่ง username ไป
    });

    // เมื่อถูกตัดการเชื่อมต่อ
    socket.onDisconnect((_) {
      print('❌ หลุดการเชื่อมต่อจากเซิร์ฟเวอร์');
    });

    // ฟัง event อื่น ๆ จาก server ได้ เช่น (ในอนาคต)
    // socket.on('game_update', (data) { ... });
  }
}
