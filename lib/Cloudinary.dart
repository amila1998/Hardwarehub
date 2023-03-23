class Cloudinary {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  Cloudinary({required this.cloudName, required this.apiKey, required this.apiSecret});

  static Cloudinary fromConfig(Map<String, String> config) {
    final cloudName = config['cloudName'];
    final apiKey = config['apiKey'];
    final apiSecret = config['apiSecret'];
    if (cloudName == null || apiKey == null || apiSecret == null) {
      throw Exception('Invalid configuration');
    }
    return Cloudinary(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret);
  }
}