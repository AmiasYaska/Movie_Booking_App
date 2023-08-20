
// import 'dart:convert';
// import 'dart:html';
// import 'package:http/http.dart' as http;


// void book(String id,String movieId ,String cinemaId, String email, String seatNumber, String showDate, String showTime) async {
//   var url = Url.parse('http://127.0.0.1:8000/api/bookings/'); 
//   var response = await http.post(
  
//   url,
//   body:jsonEncode(<String,String>{
   
//     'id': id,
//      'movieid':'id'
//     'cinema_id': cinemaId,
//     'email': email,
//     'seatnumber': seatNumber,
//     'showdate': showDate,
//     'showtime': showTime,
//   }),);
//    var jsonData = json.decode(response.body);

//   if (response.statusCode == 200) {
//     final responseData = jsonDecode(response.body);
//     print(responseData['message']); 
//   } else if (response.statusCode == 404) {
//     print('Movie or Cinema not found'); 
//   } else {
//     print('Something went wrong'); 
//   }
// }


