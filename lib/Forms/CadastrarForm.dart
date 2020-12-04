class CadastrarForm {
  String usuario;
  String senha;
  String tipo;

  void adicionarUsuario(String usuario) {
    this.usuario = usuario;
  }

  String pegarUsuario() {
    return this.usuario;
  }

  void adicionarSenha(String senha) {
    this.senha = senha;
  }

  String pegarSenha() {
    return this.senha;
  }
}
