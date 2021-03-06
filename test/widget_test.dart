// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:task/main.dart';

void main() {
  print(getDiagonals(7));
}


getDiagonals(int target){
  List<int> numList =[];
  List<Map<String,int>> firstDiagonalList =[];
  List<Map<String,int>> secondDiagonalList =[];

  numList = List<int>.generate(target, (index) => index);

  for(int i=0; i<target; i++){
    firstDiagonalList.add({'x':i,'y':i});
    for(int j=i; j<target; j++){
      if(numList[i] + numList[j] == target-1){
        secondDiagonalList.add({'x':i,'y':j});
        if(i != j) secondDiagonalList.add({'x':j,'y':i});

      }
    }
  }

  print('First Diagonal: $firstDiagonalList');
  print('Second Diagonal: $secondDiagonalList');

}

