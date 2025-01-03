class Note {
  final String id;
  final String title;
  final String type; 
  String? color; 
  final List<String>? tags; 
  final dynamic content;
  final List<String>? checklistItems; 
  final String? imagePath;
  final DateTime? eventDate; 
  final String? eventLocation;

  final bool isImprotant;

  Note({
    required this.id,
    required this.title,
    required this.type,
    this.color,
    this.tags,
    this.content,
    this.checklistItems,
    this.imagePath,
    this.eventDate,
    this.eventLocation,

    this.isImprotant = false,
  });
  Note copyWith({
    String? title,
    String? content,
    List<String>? tags,
    bool? isImprotant,
    String? id,
    String? type,
    List<String>? checklistItems,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      isImprotant: isImprotant ?? this.isImprotant,
      id: id ?? this.id,
      type: type ?? this.type,
      checklistItems: checklistItems ?? this.checklistItems,
    );
  }
}


