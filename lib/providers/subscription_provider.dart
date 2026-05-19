import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionState {
  final bool isPro;
  final String? activeEntitlement;
  const SubscriptionState({required this.isPro, this.activeEntitlement});
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  SubscriptionController() : super(const SubscriptionState(isPro: false));

  Future<void> configure(String apiKey) async {
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
      final info = await Purchases.getCustomerInfo();
      _onCustomerInfo(info);
    } catch (_) {
      // RevenueCat not configured in dev; stay on free tier.
    }
  }

  void _onCustomerInfo(CustomerInfo info) {
    final pro = info.entitlements.active['pro'];
    state = SubscriptionState(
      isPro: pro != null,
      activeEntitlement: pro?.identifier,
    );
  }

  Future<Offerings?> offerings() async {
    try {
      return await Purchases.getOfferings();
    } catch (_) {
      return null;
    }
  }

  Future<bool> buy(Package pkg) async {
    try {
      await Purchases.purchasePackage(pkg);
      return state.isPro;
    } catch (_) {
      return false;
    }
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionState>((ref) {
  return SubscriptionController();
});
