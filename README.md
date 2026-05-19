# flutter-livestock-homestead

Flutter POC for a multi-species homestead management platform targeting backyard
farmers. Single codebase covering iPhone + iPad + Android. Offline-first storage
with cross-device sync, RevenueCat subscriptions, push notifications.

## Stack

- Flutter + Dart (single codebase)
- Riverpod (state)
- go_router (navigation)
- Hive (offline-first local storage, zero-internet operation)
- RevenueCat (`purchases_flutter`) for StoreKit 2 / Google Play Billing
- fl_chart (financial + production dashboards)
- intl (i18n + dates)

## Domain model

- **Species** - Chicken, Goat, Cow, Sheep, Pig, Rabbit, Bee, Garden (phase 2)
- **Animal** - id, species, name, birth, weight log, breeding records, status
- **Health log** - vaccinations, vet visits, medications, notes per animal
- **Production record** - eggs/day, milk/day, kg meat, honey kg
- **Financial entry** - feed cost, vet cost, sale revenue, equipment
- **Savings goal** - target amount, contribution rules, projected hit date

## Offline-first design

Hive boxes per entity (`animals`, `health_logs`, `production`, `finance`,
`savings`). All writes go to Hive first and emit a sync event. A background sync
worker pushes/pulls deltas when `connectivity_plus` reports online. Conflict
resolution uses last-write-wins on a per-field basis with a manual review queue
for high-risk fields (status changes).

## RevenueCat subscriptions

Tiers: Free (1 species, 5 animals) / Pro (unlimited) / Family (multi-user sync).

```dart
await Purchases.configure(PurchasesConfiguration(rcApiKey));
final offerings = await Purchases.getOfferings();
await Purchases.purchasePackage(offerings.current!.monthly!);
```

Webhook handling lives on your backend; the app reacts via
`Purchases.addCustomerInfoUpdateListener`.

## Run

```bash
flutter pub get
flutter run
```
