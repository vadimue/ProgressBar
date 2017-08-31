import UIKit

extension UIColor {

  var redValue: Float{
    return component(for: 0)
  }

  var greenValue: Float{
    return component(for: 1)
  }

  var blueValue: Float{
    return component(for: 2)
  }

  var alphaValue: Float{
    return component(for: 3)
  }

  private func component(for index: Int) -> Float {
    return Float(cgColor.components?[safe: index] ?? 0)
  }
}

extension Collection where Indices.Iterator.Element == Index {
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
