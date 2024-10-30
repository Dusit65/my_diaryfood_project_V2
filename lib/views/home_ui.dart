// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unused_local_variable, must_call_super, annotate_overrides

import 'package:flutter/material.dart';
import 'package:my_diaryfood_project/models/diaryfood.dart';
import 'package:my_diaryfood_project/models/member.dart';
import 'package:my_diaryfood_project/services/call_api.dart';
import 'package:my_diaryfood_project/utils/env.dart';
import 'package:my_diaryfood_project/views/update_profile_ui.dart';

class HomeUI extends StatefulWidget {
  Member? member;

  HomeUI({super.key, this.member});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
//ตัวแปรเก็บข้อมูลการกินที่ได้ขากการเรียกใช้API
  Future<List<Diaryfood>>? diaryfoodData;

//สร้างฟังก์ชันเรียกใช้API
  getAllDiaryFoodByMember(Diaryfood diaryfood)  {
    setState(() {
      diaryfoodData = CallAPI.callGetAllDiaryfoodByMemberAPI(diaryfood);
    });
  }
  @override

  void initState() {
    //สร้างตัวแปรเก็บข้อมูลที่ขะส่งไปตตอนเรียกapi
    Diaryfood diaryfood = Diaryfood(
      memId: widget.member!.memId,
    );
    //call api
    getAllDiaryFoodByMember(diaryfood);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
//AppBar
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'บันทึกการกิน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.045,
          ),
//Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://cdn.pixabay.com/photo/2020/02/02/03/39/man-4811935_1280.png",
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
//FullName
          Text(
            'ชื่อ-สกุล : ${widget.member!.memFullName}',
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
//Email
          Text(
            'อีเมล : ${widget.member!.memEmail}',
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileUi(member: widget.member,),
                ),
              ).then((value){
                //เอาค่าที่ส่งกลับมาหลังจากแก้ไขเสร็จมาแก้ไขให้กับwidget.member
                if (value != null){
                setState(() {
                  widget.member?.memEmail = value.memEmail;
                  widget.member?.memUsername = value.memUsername;
                  widget.member?.memPassword = value.memPassword;
                  widget.member?.memAge = value.memAge;
                });
                }
              });
            },
            child: Text(
              'UPDATE PROFILE',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  color: Colors.orange),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Diaryfood>>(
              future: diaryfoodData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                    if(snapshot.data![0].message == "0"){
                      return Text("ยังไม่ได้บันทึกการกิน");
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {},
                                tileColor: index % 2 == 0 ? Colors.red[50] : Colors.green[50],
                                leading: ClipRRect(
                                  child: Image.network(
                                    '${Env.hostName}/mydiaryfood/assets/images/picupload/foods/${snapshot.data![index].foodImage}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index].foodShopname!,
                                  ),
                                  subtitle: Text(
                                    'วันที่บันทึก : ${snapshot.data![index].foodDate}',
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.green[800],
                                  ),
                                ),
                              Divider(),
                            ],
                          );
                        }
                      );
                    }
                }else{
                  return CircularProgressIndicator();
                }
              }
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.045,
          ),
          
        ],
      )),
    );
  }
}