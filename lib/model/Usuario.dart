class Usuario {
  String _id;
  String _nome;
  String _email;
  String _senha;
  int _tipo;
  String _idRestaurante;


  void adicionarNome(String nome) {
    this._nome = nome;
  }

  String pegarNome() {
    return this._nome;
  }

  void adicionarEmail(String email) {
    this._email = email;
  }

  String pegarEmail() {
    return this._email;
  }

  void adicionarSenha(String senha) {
    this._senha = senha;
  }

  String pegarSenha() {
    return this._senha;
  }

  void adicionarTipo(int tipo) {
    print("Tipo: "+tipo.toString());
    this._tipo = tipo;
  }

  int pegarTipo() {
    return this._tipo;
  }

  void adicionarId(String id) {
    this._id = id;
  }

  String pegarId() {
    return this._id;
  }

  void adicionarIdRestaurante(String id) {
    this._idRestaurante = id;
  }

  String pegarIdRestaurante() {
    return this._idRestaurante;
  }

  Map<String, dynamic> pegarUsuarioDados() {
    Map<String, dynamic> map = {
      "nome": this._nome,
      "email": this._email,
      "tipo": this._tipo.toString(),
      "id" : this._id,
      "restaurante": this._idRestaurante
    };
    return map;
  }
}
