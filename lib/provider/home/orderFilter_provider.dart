

import 'package:flutter/material.dart';
import 'package:purchaseproject/model/order_model.dart';
import 'package:purchaseproject/service/home/filter_service.dart';

class FilterProvider extends ChangeNotifier {
  final FilterService _service = FilterService();

  List<OrderModel> filteredOrders = [];
  bool isFiltering = false;

  String? selectedStatus;
  double? minAmount;
  double? maxAmount;
  DateTime? startDate;
  DateTime? endDate;
  String? sortType;

  // applay filter
  Future<void> applyFilter() async {
    isFiltering = true;
    notifyListeners();

    filteredOrders = [];

    try {
      filteredOrders = await _service.getFilteredOrders(
        status: selectedStatus,
        minAmount: minAmount,
        maxAmount: maxAmount,
        startDate: startDate,
        endDate: endDate,
        sortType: sortType,
      );
    } catch (e) {
      filteredOrders = [];
      debugPrint('FilterProvider.applyFilter error: $e');
    } finally {
      isFiltering = false;
      notifyListeners();
    }
  }

  //Reset filter
  void clearFilter() {
    selectedStatus = null;
    minAmount = null;
    maxAmount = null;
    startDate = null;
    endDate = null;
    sortType = null;
    filteredOrders.clear();
    notifyListeners();
  }


  bool get isFilterActive =>
      selectedStatus != null ||
      minAmount != null ||
      maxAmount != null ||
      startDate != null ||
      endDate != null ||
      sortType != null;
}
