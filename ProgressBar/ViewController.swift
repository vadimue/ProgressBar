import UIKit

func delay(_ seconds: Double, handler: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
    handler()
  }
}

class ViewController: UIViewController {

  @IBOutlet weak var progressView: ProgressView!
  @IBOutlet weak var progressLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.progressView.set(progress: 0.0)
    self.progressLabel.text = "0%"

    delay(2) {
      self.progressView.set(progress: 0.3)
      self.progressLabel.text = "30%"
    }

    delay(4) {
      self.progressView.set(progress: 0.66)
      self.progressLabel.text = "66%"
    }

    delay(6) {
      self.progressView.set(progress: 1)
      self.progressLabel.text = "100%"
    }
  }
}

