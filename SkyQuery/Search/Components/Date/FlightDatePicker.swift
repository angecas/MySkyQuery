//
//  FlightDatePicker.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import UIKit

protocol FlightDatePickerDelegate: AnyObject {
    func flightDatePicker(_ datePicker: FlightDatePicker, didPick date: Date, for textField: UITextField)
    func flightDatePicker(_ datePicker: FlightDatePicker, didFinishFor textField: UITextField)
}

class FlightDatePicker: UIView {
    weak var delegate: FlightDatePickerDelegate?
    
    // MARK: - Constants
    private enum Constants {
        static let radius: CGFloat = 4
        static let stackSpacing: CGFloat = 24
        static let verticalSpacing: CGFloat = 8
        static let height: CGFloat = 52
        static let toolBarButtonHeight: CGFloat = 36
        static let datePickerHeightRatio: CGFloat = 0.5
        static let dateFormat: String = "yyyy-MM-dd"
    }
    
    // MARK: - Properties
    var placeholder: String = NSLocalizedString("select_flight_date", comment: "") {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    // MARK: - UI Components
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.setPlaceholderColor(.gray)
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.radius
        textField.setLeftIcon(named: "calendar", tintColor: .systemBlue)
        textField.layer.masksToBounds = true
        textField.accessibilityIdentifier = "dateField"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date()
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.toolBarButtonHeight))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupDatePicker()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: Constants.height),
        ])
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        
        let screenHeight = UIScreen.main.bounds.height
        let estimatedHeight = screenHeight * Constants.datePickerHeightRatio
        
        datePicker.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: estimatedHeight
        )

        textField.inputView = datePicker

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneDatePicker)
        )

        toolBar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }

    // MARK: - Actions
    @objc private func doneDatePicker() {
        delegate?.flightDatePicker(self, didFinishFor: textField)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        delegate?.flightDatePicker(self, didPick: sender.date, for: textField)
    }
    
    
    func setDate(_ dateString: String?) {
        guard let dateString = dateString else {
            textField.text = nil
            datePicker.date = Date()
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: dateString) {
            datePicker.date = date
            textField.text = dateString
        } else {
            textField.text = nil
            datePicker.date = Date()
        }
    }
}
