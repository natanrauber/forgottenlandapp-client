class PATH {
  static const String tibiaDataApi = 'https://api.tibiadata.com/v4';
  static const String forgottenLandApi = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://forgottenlandapi.up.railway.app',
  );
}
