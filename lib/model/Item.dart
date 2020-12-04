class Item {
  String _nome;
  String _preco;
  String _descr;
  String _id;
  String _url;
  String _idRestaurante;

  void adicionarNome(String nome) {
    this._nome = nome;
  }

  String pegarNome() {
    return this._nome;
  }

  void adicionarPreco(String preco) {
    this._preco = preco;
  }

  String pegarPreco() {
    return this._preco;
  }

  void adicionarDescr(String descr) {
    this._descr = descr;
  }

  String pegarDescr() {
    return this._descr;
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

  void adicionarUrl(String url) {
    this._url = url;
  }

  String pegarUrl() {
    return this._url;
  }

  Map<String, dynamic> pegarItensDados() {
    Map<String, dynamic> map = {
      "nome": this._nome,
      "preco": this._preco,
      "descr": this._descr.toString(),
      "id": this._id,
      "url": this._url,
      "id_restaurante": this._idRestaurante
    };
    return map;
  }
}
