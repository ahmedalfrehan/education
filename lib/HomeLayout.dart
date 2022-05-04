import 'package:education_evaluation/sharedHELper.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
import 'constant.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var far = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<Education, Educational>(
          listener: (context, state) {},
          builder: (context, state) {
            var c = Education.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  titleSpacing: 0,
                  backgroundColor: const Color(0xFF0b4972),
                  centerTitle: true,
                  title: Text(
                    c.titles[c.currrentIndex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: isAllowedToShown == null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        color: const Color(0xFFECF0F3),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              const Center(
                                child: Text(
                                  'اختر المحافظة والمادة ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        alignment: Alignment.center,
                                        elevation: 15,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        hint: Text(
                                          government,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        items: Education.get(context)
                                            .government
                                            .map((String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) async {
                                          await Shard.saveData(
                                                  key: 'government',
                                                  value: newValue)
                                              .then(
                                            (value) {
                                              government = Education.get(context)
                                                  .changeStringV(government,
                                                      newValue.toString());
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Form(
                                key: far,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        labelText: 'المادة'),
                                    controller:
                                        Education.get(context).itemsController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'the item must not be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    side: const BorderSide(),
                                    primary: const Color(0xFF0b4972),
                                    elevation: 7,
                                    shape:
                                        const StadiumBorder(side: BorderSide()),
                                    fixedSize: const Size(300, 50),
                                  ),
                                  onPressed: () async {
                                    if (far.currentState!.validate()) {
                                      if (!Education.get(context)
                                          .government
                                          .contains(government)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('اختر المحافظة'),
                                          ),
                                        );
                                      }
                                      await Shard.saveData(
                                              key: 'items',
                                              value: Education.get(context)
                                                  .itemsController
                                                  .text)
                                          .then((value) async {
                                        if (Education.get(context)
                                            .government
                                            .contains(government)) {
                                          bool t = true;
                                          await Shard.saveData(
                                                  key: 'isAllow', value: false)
                                              .then((value) {
                                            isAllowedToShown =
                                                Education.get(context)
                                                    .changeBoolean(t, false);
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "حفظ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFFECF0F3),
                        child: c.list[c.currrentIndex]),
                bottomNavigationBar: CurvedNavigationBar(
                  index: c.currrentIndex,
                  items: const <Widget>[
                    Icon(Icons.home_outlined, size: 30, color: Color(0xFFd4b614)),
                    Icon(Icons.school_outlined,
                        size: 30, color: Color(0xFFd4b614)),
                    Icon(
                      Icons.add_circle,
                      size: 50,
                      color: Color(0xFF0b4972),
                    ),
                    Icon(Icons.search, size: 30, color: Color(0xFFd4b614)),
                    Icon(Icons.send_outlined,
                        textDirection: TextDirection.ltr,
                        size: 30,
                        color: Color(0xFFd4b614)),
                  ],
                  color: Colors.white,
                  buttonBackgroundColor: c.currrentIndex == 2
                      ? Colors.white
                      : const Color(0xFF0b4972),
                  backgroundColor: const Color(0xFFECF0F3),
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 600),
                  onTap: (index) {
                    c.ChangeBottomNav(index);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
