class BuildInfo {
  static const String timestamp = String.fromEnvironment('BUILD_TIMESTAMP');
  static const String sha = String.fromEnvironment('BUILD_SHA');

  static String get shortSha =>
      sha.length >= 7 ? sha.substring(0, 7) : sha;

  static bool get hasInfo => timestamp.isNotEmpty || sha.isNotEmpty;
}
