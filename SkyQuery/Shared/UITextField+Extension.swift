import UIKit

extension UITextField {
    func setLeftIcon(named systemImageName: String, tintColor: UIColor = .gray) {
        let image = UIImage(systemName: systemImageName)
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: color]
        )
    }
}
