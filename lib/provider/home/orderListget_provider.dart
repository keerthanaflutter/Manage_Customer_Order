import 'dart:async';
import 'package:flutter/material.dart';
import 'package:purchaseproject/model/order_model.dart';
import 'package:purchaseproject/service/home/orderListget_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  bool isLoading = false;

  final Set<String> _updatingIds = {};
  final Set<String> _deletingIds = {};

  bool isUpdating(String id) => _updatingIds.contains(id);
  bool isDeleting(String id) => _deletingIds.contains(id);

  StreamSubscription? _orderSubscription;

  void listenToOrders() {
    isLoading = true;
    notifyListeners();

    _orderSubscription?.cancel();

    _orderSubscription = _service.getOrders().listen(
      (orderList) async {
        await Future.delayed(const Duration(seconds: 5)); 

        _orders = orderList;
        isLoading = false;
        notifyListeners();
      },
      onError: (e) async {
        debugPrint('orders stream error: $e');
        await Future.delayed(const Duration(seconds: 5));
        isLoading = false;
        notifyListeners();
      },
    );
  }

  // Refresh
  Future<void> refreshOrders() async {
    isLoading = true;
    notifyListeners();

    _orderSubscription?.cancel();

    final completer = Completer<void>();

    _orderSubscription = _service.getOrders().listen(
      (orderList) async {
        await Future.delayed(const Duration(seconds: 5)); 

        _orders = orderList;
        isLoading = false;
        notifyListeners();

        if (!completer.isCompleted) completer.complete();
      },
      onError: (e) async {
        await Future.delayed(const Duration(seconds: 5));

        isLoading = false;
        notifyListeners();

        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future;
  }

  //Delete
  Future<bool> deleteOrder(String id) async {
    try {
      _deletingIds.add(id);
      notifyListeners();

      await _service.deleteOrder(id);

      _deletingIds.remove(id);
      notifyListeners();

      return true;
    } catch (e) {
      _deletingIds.remove(id);
      notifyListeners();
      return false;
    }
  }

  //Update status
  Future<bool> updateStatus(String id, String status) async {
    _updatingIds.add(id);
    notifyListeners();

    final ok = await _service.updateStatus(id, status);

    _updatingIds.remove(id);
    notifyListeners();

    return ok;
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }
}
