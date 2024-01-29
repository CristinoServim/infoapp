String encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
  }).join('&');
}
