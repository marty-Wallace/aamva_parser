
import 'height.dart';

enum WeightUnit {
  LBS,
  KG
}

class Weight {
  WeightUnit weightUnit;
  int weight;

  Weight(int weight, WeightUnit weightUnit) {
    this.weightUnit = weightUnit;

    // this is a weight range
    if(weight >= 0 && weight < 10) {
      if(weightUnit == WeightUnit.LBS) {
        this.weight = getImperialRangeWeight(weight);
      } else {
        this.weight = getMetricRangeWeight(weight);
      }
    } else {
      this.weight = weight;
    }
  }

  bool operator == (o) => o is Weight && o.weight == weight && o.weightUnit == weightUnit;
  int get hashCode {
    return weight.hashCode * 31 + weightUnit.hashCode;
  }

  static int getImperialRangeWeight(int range) {
    var table = { 0 : 50, 1 : 85, 2 : 115, 3 : 145, 4 : 175, 5 : 205,
      6 : 235, 7 : 265, 8 : 300, 9 : 320 };
    return table[range];
  }

  static int getMetricRangeWeight(int range) {
    var table = { 0 : 20, 1 : 38, 2 : 53, 3 : 65, 4 : 79, 5 : 94,
      6 : 107, 7 : 121, 8 : 137, 9 : 146 };
    return table[range];
  }

  static WeightUnit inferWeightUnitFromHeightUnit(HeightUnit heightUnit) {
    return heightUnit == HeightUnit.CM ? WeightUnit.KG : WeightUnit.LBS;
  }

}