/// Application configuration.
///
/// Set [baseUrl] to match your ASP.NET Core Web API server address.
/// Example: 'http://192.168.1.10:5000' or 'https://api.resorthub-yemen.com'
class AppConfig {
  AppConfig._();

  /// ⚠️  Change this to your actual server URL before running.
  static const String baseUrl = 'http://localhost:5191';

  // ─────────────────────────── Auth endpoints ──────────────────────────────
  static const String loginEndpoint    = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';

  // ── Existing CRUD endpoints (used by selection sync) ──────────────────────
  static const String membersEndpoint       = '/api/Members';
  static const String subscriptionsEndpoint = '/api/Subscriptions';

  // ── Timeout settings ──────────────────────────────────────────────────────
  static const Duration requestTimeout = Duration(seconds: 15);
}
