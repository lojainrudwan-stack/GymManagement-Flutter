import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import '../config/app_config.dart';

class SignalRService {
  SignalRService._privateConstructor();
  static final SignalRService instance = SignalRService._privateConstructor();

  HubConnection? _hubConnection;

  // Callbacks for UI updates
  Function(List<Object?>?)? onTrainerAdded;
  Function(List<Object?>?)? onTrainerUpdated;
  Function(List<Object?>?)? onTrainerDeleted;

  Function(List<Object?>?)? onPackageAdded;
  Function(List<Object?>?)? onPackageUpdated;
  Function(List<Object?>?)? onPackageDeleted;

  Function(List<Object?>?)? onSubscriptionAdded;
  Function(List<Object?>?)? onSubscriptionUpdated;
  Function(List<Object?>?)? onSubscriptionDeleted;

  // Callback for reconnection events to refresh UI state
  Function()? onReconnected;

  Future<void> init() async {
    if (_hubConnection != null) return;

    final hubUrl = '${AppConfig.baseUrl}/gymHub';

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .build();

    // Trainer events
    _hubConnection?.on('TrainerAdded', (arguments) => onTrainerAdded?.call(arguments));
    _hubConnection?.on('TrainerUpdated', (arguments) => onTrainerUpdated?.call(arguments));
    _hubConnection?.on('TrainerDeleted', (arguments) => onTrainerDeleted?.call(arguments));

    // Package events
    _hubConnection?.on('PackageAdded', (arguments) => onPackageAdded?.call(arguments));
    _hubConnection?.on('PackageUpdated', (arguments) => onPackageUpdated?.call(arguments));
    _hubConnection?.on('PackageDeleted', (arguments) => onPackageDeleted?.call(arguments));

    // Subscription events
    _hubConnection?.on('SubscriptionAdded', (arguments) => onSubscriptionAdded?.call(arguments));
    _hubConnection?.on('SubscriptionUpdated', (arguments) => onSubscriptionUpdated?.call(arguments));
    _hubConnection?.on('SubscriptionDeleted', (arguments) => onSubscriptionDeleted?.call(arguments));

    // Connection lifecycle callbacks
    // Connection lifecycle callbacks
    _hubConnection?.onclose(({Exception? error}) {
      Logger.root.warning('SignalR connection closed: $error');
    });
    _hubConnection?.onreconnected(({String? connectionId}) {
      Logger.root.info('SignalR reconnected: $connectionId');
      onReconnected?.call();
    });

    try {
      await _hubConnection?.start();
      Logger.root.info('SignalR connected to $hubUrl');
    } catch (e) {
      Logger.root.severe('Error connecting to SignalR: $e');
    }
  }

  void stop() {
    _hubConnection?.stop();
  }
}
