class {{ cookiecutter.feature_name|title }}Item {
  {{ cookiecutter.feature_name|title }}Item(this.id);

  static final mock = [
    {{ cookiecutter.feature_name|title }}Item("id"),
  ];

  final String id;
}