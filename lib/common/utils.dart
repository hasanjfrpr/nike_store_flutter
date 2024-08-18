

import 'package:intl/intl.dart';

extension PriceLable on int {
  String get withPricelable=>this>0?'$numberFormatter تومان':'رایگان';

  String get numberFormatter{
    final numberFormat= NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}