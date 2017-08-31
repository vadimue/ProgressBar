import Foundation
import UIKit

@IBDesignable
class ProgressView: UIView {

  let dotWidth: CGFloat = 5.0
  let dotHeigh: CGFloat = 18.0
  let dotOffset: CGFloat = 8.0
  let dotRadius: CGFloat = 3.0

  let startColor: UIColor = UIColor(red: 162.0/255.0, green: 168.0/255.0, blue: 247.0/255.0, alpha: 1)
  let endColor: UIColor = UIColor(red: 40.0/255.0, green: 221.0/255.0, blue: 255.0/255.0, alpha: 1)
  let substrateColor = UIColor(red: 223.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)

  let replicator = CAReplicatorLayer()
  let substrate = CAReplicatorLayer()
  let dot = CALayer()
  let substrateDot = CALayer()

  private var progress: Float = 0.0

  private let instanceCountKey = "instanceCount"

  override func didMoveToWindow() {
    super.didMoveToWindow()
    addReplicators()
  }

  private func addReplicators() {
    let transform = CATransform3DMakeTranslation(dotOffset, 0.0, 0.0)

    substrate.instanceTransform = transform
    substrate.addSublayer(substrateDot)
    layer.addSublayer(substrate)

    replicator.instanceTransform = transform
    replicator.addSublayer(dot)
    layer.addSublayer(replicator)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layoutDot()
    layoutReplicator()
    set(progress: progress, animated: false)
  }

  private func layoutDot() {
    let dotFrame = CGRect(x: 0, y: (frame.height - dotHeigh)/2, width: dotWidth, height: dotHeigh)

    dot.frame = dotFrame
    dot.backgroundColor = startColor.cgColor
    dot.cornerRadius = dotRadius

    setupDotShadow()

    substrateDot.frame = dotFrame
    substrateDot.backgroundColor = substrateColor.cgColor
    substrateDot.cornerRadius = dotRadius
  }

  private func setupDotShadow() {
    dot.shadowColor = dot.backgroundColor
    dot.shadowOpacity = 0.5
    dot.shadowOffset = CGSize(width: 3, height: 5)
    dot.shadowRadius = 6
    dot.shouldRasterize = true
  }

  private func layoutReplicator() {
    replicator.frame = bounds

    let instanceCount = Int(replicator.frame.width / dotOffset)
    setupReplicatorColorOffset(for: instanceCount)

    substrate.frame = bounds
    substrate.instanceCount = instanceCount
  }

  private func setupReplicatorColorOffset(for instanceCount: Int) {
    let instanceCountFloat = Float(instanceCount)
    replicator.instanceRedOffset = -(startColor.redValue-endColor.redValue)/instanceCountFloat
    replicator.instanceGreenOffset = -(startColor.greenValue-endColor.greenValue)/instanceCountFloat
    replicator.instanceBlueOffset = -(startColor.blueValue-endColor.blueValue)/instanceCountFloat
  }

  func set(progress value: Float, animated: Bool = true) {
    progress = getValidProgress(from: value)

    adjustReplicatorHiding()
    replicator.removeAnimation(forKey: instanceCountKey)

    let previousInstanceCount = replicator.instanceCount
    let instanceCount = Int(replicator.frame.width / dotOffset * CGFloat(progress))
    replicator.instanceCount = instanceCount

    if animated {
      addCountAnimation(from: previousInstanceCount, to: instanceCount)
    }
  }

  private func getValidProgress(from value: Float) -> Float {
    if value < 0 {
      return 0.0
    } else if value > 1 {
      return 1.0
    } else {
      return value
    }
  }

  private func adjustReplicatorHiding() {
    if progress.isEqual(to: 0.0) {
      replicator.isHidden = true
    } else {
      replicator.isHidden = false
    }
  }

  private func addCountAnimation(from: Int, to: Int) {
    let count = CABasicAnimation(keyPath: "instanceCount")
    count.fromValue = from
    count.toValue = to
    count.duration = 0.66
    count.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    replicator.add(count, forKey: instanceCountKey)
  }
}
