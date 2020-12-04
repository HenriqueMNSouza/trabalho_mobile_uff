class ItemConta {
  bool _emAberto = true;
  String _idCardapio;
  String _idUsuario;

  void adicionarIdCardapio(String idCardapio) {
    this._idCardapio = idCardapio;
  }

  String pegarIdCardapio() {
    return this._idCardapio;
  }

  void adicionarIdUsuario(String idUsuario) {
    this._idUsuario = idUsuario;
  }

  String pegaridUsuario() {
    return this._idUsuario;
  }

  Map<String, dynamic> pegarItensContaDados() {
    Map<String, dynamic> map = {
      "emAberto": this._emAberto,
      "id_cardapio": this._idCardapio,
      "id_usuario": this._idUsuario
    };
    return map;
  }
}
