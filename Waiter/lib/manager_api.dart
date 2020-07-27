import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'auth.dart';
import 'item.dart';
import 'type.dart';

Future<bool> tableExists( int tableId ) async {
  try {
    var response = await http.get( manager_api + 'tables/$tableId', headers: headers ).timeout( Duration( seconds: 3 ) );

    if ( response.statusCode == HttpStatus.ok )
      return true;

    return false;
  }
  catch ( e ) {
    return false;
  }
}

Future<List<Item>> fetchItems() async {
  try {
    List<Item> items = [];
    var response = await http.get( manager_api + 'items/', headers: headers ).timeout( Duration( seconds: 3 ) );

    if ( response.statusCode != HttpStatus.ok )
      return items;

    List<dynamic> responseItems = jsonDecode(response.body)['items'];
    responseItems.forEach( (item) {
      items.add( Item( item[ 'id' ],
        item[ 'name' ],
        item[ 'price' ],
        item[ 'description' ],
        getItemImage( item[ 'imagePath' ] ),
        item[ 'calories' ],
        item[ 'carbohydrates' ],
        item[ 'fat' ],
        item[ 'protein' ],
        getItemTypes( item[ 'types' ] ),) );
    });

    return items;
  }
  catch ( e ) {
    return [];
  }
}

String getItemImage( item ) {
  String imagePath = item.toString();
  int lastSlash = imagePath.lastIndexOf( '/' );
  if ( lastSlash == -1 )
    return null;

  int imageNameIndex = lastSlash + 1;
  String imageName = imagePath.substring( imageNameIndex );

  String networkImagePath = website + imageName;
  return networkImagePath;
}

List<Type> getItemTypes( List<dynamic> itemTypes ) {
  List<Type> types = [];
  
  itemTypes.forEach( (type) {
    types.add( Type( type[ 'name' ] ) );
  });

  return types;
}

Future<List<Type>> fetchTypes() async {
  try {
    List<Type> types = [];
    var response = await http.get( manager_api + 'types/', headers: headers ).timeout( Duration( seconds: 3 ) );

    if ( response.statusCode != HttpStatus.ok )
      return types;

    List<dynamic> responseTypes = jsonDecode(response.body)['types'];
    responseTypes.forEach( (type) {
      types.add( Type( type['name'] ) );
    });
    return types;
  }
  catch ( e ) {
    return [];
  }
}