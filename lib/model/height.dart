
enum HeightUnit {
  IN,
  CM
}

class Height {
  HeightUnit heightUnit;
  int height;
  Height(this.height, this.heightUnit);

  bool operator == (o) => o is Height && o.height == height && o.heightUnit == heightUnit;
  int get hashCode {
    return height.hashCode * 31 + heightUnit.hashCode;
  }

}