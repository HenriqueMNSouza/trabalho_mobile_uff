class RestauranteForm {
  String nome;
  String endereco;
  String mesas;
  String horaAbre;
  String horaFecha;
  String proprietario;

  void adicionarNome(String nome) {
    this.nome = nome;
  }

  String pegarNome() {
    return this.nome;
  }

  void adicionarEndereco(String endereco) {
    this.endereco = endereco;
  }

  String pegarEndereco() {
    return this.endereco;
  }

  void adicionarMesas(String mesas) {
    this.mesas = mesas;
  }

  String pegarMesas() {
    return this.mesas;
  }

  void adicionarHoraAbre(String horaAbre) {
    this.horaAbre = horaAbre;
  }

  String pegarHoraAbre() {
    return this.horaAbre;
  }

  void adicionarHoraFecha(String horaFecha) {
    this.horaFecha = horaFecha;
  }

  String pegarHoraFecha() {
    return this.horaFecha;
  }

  void adicionarProprietario(String proprietario) {
    this.proprietario = proprietario;
  }

  String pegarProprietario() {
    return this.proprietario;
  }

  Map<String, dynamic> pegarRestauranteDados() {
    Map<String, dynamic> restaurante = {
      'nome': this.pegarNome(),
      'endereco': this.pegarEndereco(),
      'quantidade_mesas': this.pegarMesas(),
      'hora_abre': this.pegarHoraAbre(),
      'hora_fecha': this.pegarHoraFecha(),
      'proprietario': this.pegarProprietario()
    };

    return restaurante;
  }
}
