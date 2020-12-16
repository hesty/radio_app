import 'dart:convert';

import 'package:collection/collection.dart';

class RadioModelList {
  final List<RadioModel> radios;
  RadioModelList({
    this.radios,
  });

  RadioModelList copyWith({
    List<RadioModel> radios,
  }) {
    return RadioModelList(
      radios: radios ?? this.radios,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'radios': radios?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory RadioModelList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RadioModelList(
      radios: List<RadioModel>.from(
          map['radios']?.map((x) => RadioModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioModelList.fromJson(String source) =>
      RadioModelList.fromMap(json.decode(source));

  @override
  String toString() => 'RadioModelList(radios: $radios)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is RadioModelList && listEquals(o.radios, radios);
  }

  @override
  int get hashCode => radios.hashCode;
}

class RadioModel {
  final String category;
  final String color;
  final String desc;
  final bool disliked;
  final String icon;
  final int id;
  final String image;
  final String lang;
  final String name;
  final int order;
  final String tagline;
  final String url;
  RadioModel({
    this.category,
    this.color,
    this.desc,
    this.disliked,
    this.icon,
    this.id,
    this.image,
    this.lang,
    this.name,
    this.order,
    this.tagline,
    this.url,
  });

  RadioModel copyWith({
    String category,
    String color,
    String desc,
    bool disliked,
    String icon,
    int id,
    String image,
    String lang,
    String name,
    int order,
    String tagline,
    String url,
  }) {
    return RadioModel(
      category: category ?? this.category,
      color: color ?? this.color,
      desc: desc ?? this.desc,
      disliked: disliked ?? this.disliked,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      image: image ?? this.image,
      lang: lang ?? this.lang,
      name: name ?? this.name,
      order: order ?? this.order,
      tagline: tagline ?? this.tagline,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'color': color,
      'desc': desc,
      'disliked': disliked,
      'icon': icon,
      'id': id,
      'image': image,
      'lang': lang,
      'name': name,
      'order': order,
      'tagline': tagline,
      'url': url,
    };
  }

  factory RadioModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RadioModel(
      category: map['category'],
      color: map['color'],
      desc: map['desc'],
      disliked: map['disliked'],
      icon: map['icon'],
      id: map['id'],
      image: map['image'],
      lang: map['lang'],
      name: map['name'],
      order: map['order'],
      tagline: map['tagline'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioModel.fromJson(String source) =>
      RadioModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RadioModel(category: $category, color: $color, desc: $desc, disliked: $disliked, icon: $icon, id: $id, image: $image, lang: $lang, name: $name, order: $order, tagline: $tagline, url: $url)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RadioModel &&
        o.category == category &&
        o.color == color &&
        o.desc == desc &&
        o.disliked == disliked &&
        o.icon == icon &&
        o.id == id &&
        o.image == image &&
        o.lang == lang &&
        o.name == name &&
        o.order == order &&
        o.tagline == tagline &&
        o.url == url;
  }

  @override
  int get hashCode {
    return category.hashCode ^
        color.hashCode ^
        desc.hashCode ^
        disliked.hashCode ^
        icon.hashCode ^
        id.hashCode ^
        image.hashCode ^
        lang.hashCode ^
        name.hashCode ^
        order.hashCode ^
        tagline.hashCode ^
        url.hashCode;
  }
}
