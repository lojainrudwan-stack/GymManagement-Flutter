import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user_model.dart';
import '../models/trainer_model.dart';

/// HTTP service that communicates with the ASP.NET Core backend.
///
/// Every public method returns an [ApiResult] so callers never throw —
/// network errors are caught here and surfaced as [ApiResult.fail].
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static UserModel? currentUser;
  static String? selectedTrainer;

  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept':       'application/json',
      };

  // ─────────────────────────────────────────────────────────────────────────
  // Auth
  // ─────────────────────────────────────────────────────────────────────────

  /// POST /api/auth/login
  Future<ApiResult<UserModel>> login({
    required String identifier, // email OR phone
    required String password,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginEndpoint}');
    final body = jsonEncode({
      'identifier': identifier,
      'password':   password,
    });

    try {
      final response = await _client
          .post(uri, headers: _headers, body: body)
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final user = UserModel.fromJson(json);
        currentUser = user;
        return ApiResult.ok(user);
      } else {
        final json = _tryDecode(response.body);
        final msg  = json?['message'] ?? json?['error'] ?? _statusMessage(response.statusCode);
        return ApiResult.fail(msg.toString());
      }
    } on Exception catch (e) {
      return ApiResult.fail(_friendlyError(e));
    }
  }

  /// POST /api/auth/register
  Future<ApiResult<UserModel>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender, // 'male' | 'female'
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.registerEndpoint}');
    final body = jsonEncode({
      'name':     name,
      'phone':    phone,
      'email':    email,
      'password': password,
      'gender':   gender,
    });

    try {
      final response = await _client
          .post(uri, headers: _headers, body: body)
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final user = UserModel.fromJson(json);
        currentUser = user;
        return ApiResult.ok(user);
      } else {
        final json = _tryDecode(response.body);
        final msg  = json?['message'] ?? json?['error'] ?? _statusMessage(response.statusCode);
        return ApiResult.fail(msg.toString());
      }
    } on Exception catch (e) {
      return ApiResult.fail(_friendlyError(e));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Trainer & Subscription Synchronization
  // ─────────────────────────────────────────────────────────────────────────

  /// Syncs the selected trainer to the backend Coaches table and links to the subscription.
  Future<void> syncSelectedTrainer(TrainerModel trainer) async {
    selectedTrainer = trainer.name;

    // 1. Send coach to /api/Coaches so it appears in MVC Admin Dashboard -> Trainers
    try {
      final coachUri = Uri.parse('${AppConfig.baseUrl}/api/Coaches');
      await _client.post(
        coachUri,
        headers: _headers,
        body: jsonEncode({
          'Name': trainer.name,
          'Specialization': trainer.specialty,
          'Phone': trainer.trainingHours,
          'Status': 'نشط',
        }),
      ).timeout(AppConfig.requestTimeout);
    } catch (_) {}

    // 2. If user is logged in, attach the coach to their active subscription
    final user = currentUser;
    if (user != null) {
      try {
        final searchUri = Uri.parse('${AppConfig.baseUrl}/api/Subscriptions?search=${Uri.encodeComponent(user.name)}');
        final resp = await _client.get(searchUri, headers: _headers).timeout(AppConfig.requestTimeout);
        if (resp.statusCode == 200) {
          final list = jsonDecode(utf8.decode(resp.bodyBytes)) as List<dynamic>;
          if (list.isNotEmpty) {
            final sub = Map<String, dynamic>.from(list.first as Map);
            sub['coachName'] = trainer.name;
            sub['CoachName'] = trainer.name;
            final id = sub['subscriptionId'] ?? sub['SubscriptionId'];
            if (id != null) {
              final putUri = Uri.parse('${AppConfig.baseUrl}/api/Subscriptions/$id');
              await _client.put(putUri, headers: _headers, body: jsonEncode(sub)).timeout(AppConfig.requestTimeout);
            }
          }
        }
      } catch (_) {}
    }
  }

  /// Syncs the selected package to the backend SubscriptionPlans table and to the member's profile
  Future<void> syncSelectedPackage({
    required String name,
    required String type,
    required int durationDays,
    required double price,
  }) async {
    // 1. Post to /api/SubscriptionPlans so it appears in MVC Admin Dashboard -> Packages (الباقات)
    try {
      final planUri = Uri.parse('${AppConfig.baseUrl}/api/SubscriptionPlans');
      await _client.post(
        planUri,
        headers: _headers,
        body: jsonEncode({
          'Name': name,
          'Type': type,
          'DurationDays': durationDays,
          'Price': price,
          'Status': 'نشط',
        }),
      ).timeout(AppConfig.requestTimeout);
    } catch (_) {}

    // 2. If user is logged in, also update their member record's Package field
    final user = currentUser;
    if (user != null && user.id != 0) {
      try {
        final memberUri = Uri.parse('${AppConfig.baseUrl}/api/Members/${user.id}');
        final getResp = await _client.get(memberUri, headers: _headers).timeout(AppConfig.requestTimeout);
        if (getResp.statusCode == 200) {
          final member = Map<String, dynamic>.from(jsonDecode(utf8.decode(getResp.bodyBytes)) as Map);
          member['package'] = name;
          member['Package'] = name;
          await _client.put(memberUri, headers: _headers, body: jsonEncode(member)).timeout(AppConfig.requestTimeout);
        }
      } catch (_) {}
    }
  }

  /// Fetch packages from MVC SubscriptionPlans to add alongside static ones
  Future<List<Map<String, dynamic>>> fetchSubscriptionPlans() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/SubscriptionPlans');
      final response = await _client.get(uri, headers: _headers).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return list.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }

  /// Fetch trainers from MVC Coaches to add alongside static ones
  Future<List<Map<String, dynamic>>> fetchCoaches() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/Coaches');
      final response = await _client.get(uri, headers: _headers).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return list.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }

  /// Syncs the selected subscription type (Monthly, 6 Months, Yearly) to MVC Subscriptions.
  Future<void> syncSelectedSubscriptionType({
    required String title,
    required int durationDays,
  }) async {
    final user = currentUser;
    final memberName = (user != null && user.name.isNotEmpty) ? user.name : 'مشترك التطبيق';
    final memberId = user?.id ?? 0;
    final coach = selectedTrainer ?? '';
    final now = DateTime.now();
    final endDate = now.add(Duration(days: durationDays));

    try {
      final searchUri = Uri.parse('${AppConfig.baseUrl}/api/Subscriptions?search=${Uri.encodeComponent(memberName)}');
      final resp = await _client.get(searchUri, headers: _headers).timeout(AppConfig.requestTimeout);

      if (resp.statusCode == 200) {
        final list = jsonDecode(utf8.decode(resp.bodyBytes)) as List<dynamic>;
        if (list.isNotEmpty) {
          // Update existing subscription record
          final sub = Map<String, dynamic>.from(list.first as Map);
          sub['package'] = title;
          sub['Package'] = title;
          if (coach.isNotEmpty) {
            sub['coachName'] = coach;
            sub['CoachName'] = coach;
          }
          sub['startDate'] = now.toIso8601String();
          sub['StartDate'] = now.toIso8601String();
          sub['endDate'] = endDate.toIso8601String();
          sub['EndDate'] = endDate.toIso8601String();
          sub['status'] = 'نشط';
          sub['Status'] = 'نشط';

          final id = sub['subscriptionId'] ?? sub['SubscriptionId'];
          if (id != null) {
            final putUri = Uri.parse('${AppConfig.baseUrl}/api/Subscriptions/$id');
            await _client.put(putUri, headers: _headers, body: jsonEncode(sub)).timeout(AppConfig.requestTimeout);
            return;
          }
        }
      }

      // If no existing subscription found, create a new subscription record
      final subNumber = 'SUB-${10000 + (now.millisecondsSinceEpoch % 90000)}';
      final createUri = Uri.parse('${AppConfig.baseUrl}/api/Subscriptions');
      await _client.post(
        createUri,
        headers: _headers,
        body: jsonEncode({
          'SubscriptionNumber': subNumber,
          'MemberId': memberId,
          'MemberName': memberName,
          'Package': title,
          'CoachName': coach,
          'StartDate': now.toIso8601String(),
          'EndDate': endDate.toIso8601String(),
          'Status': 'نشط',
        }),
      ).timeout(AppConfig.requestTimeout);
    } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  String _statusMessage(int code) {
    switch (code) {
      case 400: return 'بيانات غير صحيحة';
      case 401: return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 403: return 'غير مصرح بالوصول';
      case 404: return 'المستخدم غير موجود';
      case 409: return 'الحساب مسجّل مسبقاً';
      case 422: return 'بيانات غير مكتملة';
      case 500: return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      default:  return 'حدث خطأ ($code)';
    }
  }

  String _friendlyError(Exception e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('timeout')) {
      return 'انتهت مهلة الاتصال، تحقق من الشبكة';
    }
    if (msg.contains('socket') || msg.contains('connection')) {
      return 'تعذّر الاتصال بالخادم';
    }
    if (msg.contains('handshake') || msg.contains('certificate')) {
      return 'خطأ في شهادة الأمان';
    }
    return 'خطأ غير متوقع، يرجى المحاولة لاحقاً';
  }
}
