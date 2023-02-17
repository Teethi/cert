// import 'package:attendance/services/auth/auth_service.dart';
// import 'package:attendance/utilities/generics/get_arguments.dart';
// import 'package:flutter/material.dart';
// import 'package:attendance/services/cloud/concession/cloud_concession.dart';

// class ConcessionDataStudent extends StatefulWidget {
  
//   String nameData ;
//   String genderData ;
//   String nearestStationData ;
//   String addressData ;
//   String dobData ;
//   String classValueData ;
//   String periodValueData ;
//   String applicationDateData ;
//   String destinationStationData ;
//    ConcessionDataStudent({super.key,required this.nameData,
//   required this.addressData,required this.applicationDateData,
//   required this.classValueData,required this.destinationStationData,required this.dobData,required this.genderData,required this.nearestStationData,required this.periodValueData,});

//   @override
//   State<ConcessionDataStudent> createState() => _ConcessionDataStudentState();
// }

// class _ConcessionDataStudentState extends State<ConcessionDataStudent> {

//   final currentUser = AuthService.firebase().currentUser!;

//   final commonBoxDecoration = BoxDecoration(
//     borderRadius: BorderRadius.circular(20),
//     gradient: const LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [
//         Color(0xfff5f7fa),
//         Color(0xffe7edf2),
//       ],
//     ),

//     boxShadow: const [
//       BoxShadow(
//         color: Color(0xffabc2d4),
//         spreadRadius: 0.0,
//         blurRadius: 6.0,
//         offset: Offset(4, 4),
//       ),
//       BoxShadow(
//         color: Colors.white,
//         spreadRadius: 0.0,
//         blurRadius: 6.0,
//         offset: Offset(-4, -4),
//       ),
//     ],
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff1f4f8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff15001C),
//         toolbarHeight: 115,
//         automaticallyImplyLeading: false,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//         ),
//         centerTitle: true,
//         title: const Expanded(
//           child: Text(
//             'Student Details',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.visible,
//           ),
//         ),
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//           ),
//         ),
//         flexibleSpace: Container(
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.only(
//             left: 31.0,
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(
//             height: 25,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 30),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 height: 50,
//                 alignment: Alignment.centerLeft,
//                 width: MediaQuery.of(context).size.width * 0.35,
//                 decoration: commonBoxDecoration,
//                 child: Text("Name $name"),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 30),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 alignment: Alignment.centerLeft,
//                 height: 50,
//                 width: MediaQuery.of(context).size.width * 0.35,
//                 decoration: commonBoxDecoration,
//                 child: Text("Gender $_genderData"),
//               )
//             ],
//           ),
//           Container(
//             margin:
//                 const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 23),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             decoration: commonBoxDecoration,
//             child: Text("Email ${currentUser.email}"),
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 30),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 height: 50,
//                 alignment: Alignment.centerLeft,
//                 width: MediaQuery.of(context).size.width * 0.35,
//                 decoration: commonBoxDecoration,
//                 child: Text("Class $_classValueData"),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 30),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 alignment: Alignment.centerLeft,
//                 height: 50,
//                 width: MediaQuery.of(context).size.width * 0.35,
//                 decoration: commonBoxDecoration,
//                 child: Text("Period $_periodValueData"),
//               )
//             ],
//           ),
//           Container(
//             margin: const EdgeInsets.only(
//               top: 23,
//               bottom: 20,
//               left: 30,
//               right: 30,
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             // color: Colors.red,
//             decoration: commonBoxDecoration,
//             child: Text("Date of Birth $_dobData"),
//           ),
//           Container(
//             margin: const EdgeInsets.only(
//               bottom: 20,
//               left: 30,
//               right: 30,
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             // color: Colors.red,
//             decoration: commonBoxDecoration,
//             child: Text("Nearest Station $_nearestStationData"),
//           ),
//           Container(
//             margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             // color: Colors.red,
//             decoration: commonBoxDecoration,
//             child: Text("Address $_addressData"),
//           ),
//           Container(
//             margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             // color: Colors.red,
//             decoration: commonBoxDecoration,
//             child: Text("Destination Station: $_destinationStationData"),
//           ),
//           Container(
//             margin: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.35,
//             // color: Colors.red,
//             decoration: commonBoxDecoration,
//             child: Text("Application Date: $_applicationDateData"),
//           ),
//         ],
//       ),
//     );
//   }
// }
