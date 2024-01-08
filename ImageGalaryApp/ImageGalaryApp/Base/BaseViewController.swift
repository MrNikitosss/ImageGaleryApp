import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    @IBOutlet weak var customNavigationBar: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var closeBtnContainerView: UIView!
    @IBOutlet weak var rightBtnsStack: UIStackView!

    var originXOffsetScale: Double = 0.0
    var heightScale: Double = 0.0

    func addCustomPresentationSize(heightMultiplier: Double, originXOffsetScale: Double) {
        self.heightScale = heightMultiplier
        self.originXOffsetScale = originXOffsetScale
    }

    private lazy var progressHUD = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 15, y: self.view.center.y - 15, width: 30, height: 30))

    func showDefaultAlert(title: String?, message: String?, buttonName: String? = nil, _ completion: (()->Void)? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let buttonTitle = buttonName != nil ? buttonName : "OK"
        let okAction = UIAlertAction(title: buttonTitle, style: .default) {(action) in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlert(title:String,message:String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in}
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard when tapped out of textfield
        view.endEditing(true)
    }

    @IBAction func onBackNavigation() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onCloseModal() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeUnknownController() {
        if let _ = self.navigationController {
            onBackNavigation()
        } else {
            onCloseModal()
        }
    }

    func showProgress() {
        self.progressHUD = NVActivityIndicatorView(
            frame: CGRect(x: self.view.center.x - 15, y: self.view.center.y - 15, width: 30, height: 30),
            type: .circleStrokeSpin,
            color: UIColor.blue,
            padding: nil
        )

        self.view.addSubview(self.progressHUD)
        self.view.bringSubviewToFront(self.progressHUD)

        self.progressHUD.startAnimating()
    }

    func stopProgress() {
        self.progressHUD.stopAnimating()
    }
}
