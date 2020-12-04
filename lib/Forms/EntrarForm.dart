class EntrarForm {
  String email;
  String senha;

  void adicionarEmail(String email) {
    this.email = email;
  }

  String pegarEmail() {
    return this.email;
  }

  void adicionarSenha(String senha) {
    this.senha = senha;
  }

  String pegarSenha() {
    return this.senha;
  }
}
