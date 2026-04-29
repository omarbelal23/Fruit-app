abstract class AuthRepo {
  Future loginWithFacebook();
  Future loginWithGoogle();
  Future registerWithEmailPassword({
    required String email,
    required String password,
  });
  Future completeInformation({
    String? name,
    String? phoneNumber,
    String? address,
  });
}
