
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchaseproject/provider/home/productFilter_provider.dart';
import 'package:purchaseproject/provider/home/productListget_provider.dart';
import 'package:purchaseproject/utils/app_color.dart';
import 'package:purchaseproject/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _refreshOnOpen();
    }
  }

  Future<void> _refreshOnOpen() async {
    final orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final filterProvider =
        Provider.of<FilterProvider>(context, listen: false);


    filterProvider.clearFilter();
    await orderProvider.refreshOrders();
  }

  Future<void> _onRefresh() async {
    final orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final filterProvider =
        Provider.of<FilterProvider>(context, listen: false);

    filterProvider.clearFilter();
    await orderProvider.refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Orders", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: _openFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _onRefresh,
          ),
        ],
      ),

      body: Consumer2<OrderProvider, FilterProvider>(
        builder: (context, orderProvider, filterProvider, child) {

          final orders = filterProvider.isFilterActive &&
                  filterProvider.filteredOrders.isNotEmpty
              ? filterProvider.filteredOrders
              : orderProvider.orders;

          
          if (orderProvider.isLoading || filterProvider.isFiltering) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) => shimmerCard(context),
            );
          }

        
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child:  ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200),
                  Center(child: Text("No Orders Found")),
                ],
              ),
            );
          }

       
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                final formattedDate =
                    DateFormat('dd MMM yyyy, hh:mm a')
                        .format(order.createdAt);

                final isDeleting = orderProvider.isDeleting(order.id);
                final isUpdating = orderProvider.isUpdating(order.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        order.customerName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),

                      const SizedBox(height: 10),

                      

                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Total Amount ₹${order.totalAmount}",
                            style:
                                const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          Row(
                            children: [

                            
                              isUpdating
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : PopupMenuButton<String>(
                                      onSelected: (value) {
                                        _updateStatus(order.id, value);
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                            value: "Pending",
                                            child: Text("Pending")),
                                        PopupMenuItem(
                                            value: "Completed",
                                            child: Text("Completed")),
                                        PopupMenuItem(
                                            value: "Cancelled",
                                            child: Text("Cancelled")),
                                      ],
                                      child: _outlineButton("Status"),
                                    ),

                              const SizedBox(width: 8),

                             
                              isDeleting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.red),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        _showDeleteDialog(order.id);
                                      },
                                      child: _outlineButton("Delete",
                                          textColor: Colors.red,
                                          borderColor: Colors.red),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }



  Widget _outlineButton(String text,
      {Color textColor = Colors.brown,
      Color borderColor = Colors.brown}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }


  void _openFilterSheet() {
    final filterProvider =
        Provider.of<FilterProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                DropdownButtonFormField<String>(
                  value: filterProvider.selectedStatus,
                  decoration:
                      const InputDecoration(labelText: "Order Status"),
                  items: const [
                    DropdownMenuItem(
                        value: "Pending", child: Text("Pending")),
                    DropdownMenuItem(
                        value: "Completed", child: Text("Completed")),
                    DropdownMenuItem(
                        value: "Cancelled", child: Text("Cancelled")),
                  ],
                  onChanged: (val) {
                    filterProvider.selectedStatus = val;
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Min Amount"),
                        onChanged: (v) =>
                            filterProvider.minAmount =
                                double.tryParse(v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Max Amount"),
                        onChanged: (v) =>
                            filterProvider.maxAmount =
                                double.tryParse(v),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Apply Filter"),
                        onPressed: () async {
                          Navigator.pop(context);
                          await filterProvider.applyFilter();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        child: const Text("Reset"),
                        onPressed: () {
                          filterProvider.clearFilter();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _updateStatus(String id, String status) async {
    final success =
        await Provider.of<OrderProvider>(context, listen: false)
            .updateStatus(id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(success ? "Status Updated" : "Update Failed")),
    );
  }



  void _showDeleteDialog(String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Order"),
        content: const Text(
            "Are you sure you want to delete this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
            onPressed: () async {
              Navigator.pop(context);

              final success =
                  await Provider.of<OrderProvider>(context,
                          listen: false)
                      .deleteOrder(orderId);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(success
                        ? "Order Deleted"
                        : "Delete Failed")),
              );
            },
          ),
        ],
      ),
    );
  }



  Widget shimmerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: Responsive.isMobile(context) ? 110 : 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }


  Color _statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}


