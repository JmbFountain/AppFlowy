import 'dart:collection';
import 'package:flowy_editor/document/path.dart';

typedef Attributes = Map<String, Object>;

class Node extends LinkedListEntry<Node> {
  Node? parent;
  final String type;
  final LinkedList<Node> children;
  final Attributes attributes;

  Node({
    required this.type,
    required this.children,
    required this.attributes,
    this.parent,
  });

  factory Node.fromJson(Map<String, Object> json) {
    assert(json['type'] is String);

    final jType = json['type'] as String;
    final jChildren = json['children'] as List?;
    final jAttributes = json['attributes'] != null
        ? Attributes.from(json['attributes'] as Map)
        : Attributes.from({});

    final LinkedList<Node> children = LinkedList();
    if (jChildren != null) {
      children.addAll(
        jChildren.map(
          (jChild) => Node.fromJson(
            Map<String, Object>.from(jChild),
          ),
        ),
      );
    }

    final node = Node(
      type: jType,
      children: children,
      attributes: jAttributes,
    );

    for (final child in children) {
      child.parent = node;
    }

    return node;
  }

  void updateAttributes(Attributes attributes) {
    for (final attribute in attributes.entries) {
      this.attributes[attribute.key] = attribute.value;
    }
  }

  Node? childAtIndex(int index) {
    if (children.length <= index) {
      return null;
    }

    return children.elementAt(index);
  }

  Node? childAtPath(Path path) {
    if (path.isEmpty) {
      return this;
    }

    return childAtIndex(path.first)?.childAtPath(path.sublist(1));
  }

  @override
  void insertAfter(Node entry) {
    entry.parent = parent;
    super.insertAfter(entry);
  }

  @override
  void insertBefore(Node entry) {
    entry.parent = parent;
    super.insertBefore(entry);
  }

  @override
  void unlink() {
    parent = null;
    super.unlink();
  }

  Map<String, Object> toJson() {
    var map = <String, Object>{
      'type': type,
    };
    if (children.isNotEmpty) {
      map['children'] = children.map((node) => node.toJson());
    }
    if (attributes.isNotEmpty) {
      map['attributes'] = attributes;
    }
    return map;
  }
}