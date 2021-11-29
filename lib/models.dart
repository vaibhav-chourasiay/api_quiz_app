// ignore_for_file: non_constant_identifier_names, avoid_print

class Models {
  static List q = [];
  String? category;
  String? type;
  String? diffeculty;
  String? question;
  String? correct_answer;
  List? total_options;

  Models(
      {this.category,
      this.type,
      this.correct_answer,
      this.diffeculty,
      this.question,
      this.total_options});

  Models.fromMap(Map p) {
    category = p["category"];
    type = p["type"];
    diffeculty = p["difficulty"];
    question = p["question"];
    correct_answer = p["correct_answer"];

    List i = p["incorrect_answers"];
    i.add(p["correct_answer"]);
    i.shuffle();
    print(i);

    total_options = i;
  }

  tomap() {
    q.add(Models(
        category: category,
        type: type,
        correct_answer: correct_answer,
        diffeculty: diffeculty,
        question: question,
        total_options: total_options));
  }
}
