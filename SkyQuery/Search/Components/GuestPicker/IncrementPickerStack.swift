//
//  IncrementPickerStack.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import UIKit

protocol IncrementPickerStackDelegate: AnyObject {
    
    func didChangeAdults(_ view: IncrementPickerStack, value: Int)
    func didChangeTeens(_ view: IncrementPickerStack, value: Int)
    func didChangeChildren(_ view: IncrementPickerStack, value: Int)
    
}

class IncrementPickerStack: UIView {
    weak var delegate: IncrementPickerStackDelegate?

    private enum Constants {
        static let radius: CGFloat = 4
        static let stackSpacing: CGFloat = 24
        static let verticalSpacing: CGFloat = 8
        static let height: CGFloat = 52
    }
    
    // MARK: - Properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [adultPicker, teenagerPicker, childrenPicker])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var adultPicker: HostingView<IncrementControl> = createPicker(
        initialValue: 1,
        minValue: 1,
        maxValue: 6,
        title: "Adults",
        imageName: "figure.arms.open",
        valueChanged: { [weak self] newValue in
            guard let self = self else { return }
            self.delegate?.didChangeAdults(self, value: newValue)
        }
    )
    
    private lazy var teenagerPicker: HostingView<IncrementControl> = createPicker(
        initialValue: 0,
        minValue: 0,
        maxValue: 6,
        title: "Teenagers",
        imageName: "figure.arms.open",
        valueChanged: { [weak self] newValue in
            guard let self = self else { return }
            self.delegate?.didChangeTeens(self, value: newValue)
         }
    )
    
    private lazy var childrenPicker: HostingView<IncrementControl> = createPicker(
        initialValue: 0,
        minValue: 0,
        maxValue: 6,
        title: "Children",
        imageName: "figure.2.and.child.holdinghands",
        valueChanged: { [weak self] newValue in
            guard let self = self else { return }
                    self.delegate?.didChangeChildren(self, value: newValue)
        }
    )
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createPicker(
        initialValue: Int,
        minValue: Int,
        maxValue: Int,
        title: String,
        imageName: String,
        valueChanged: @escaping (Int) -> Void
    ) -> HostingView<IncrementControl> {
        let incrementControl = IncrementControl(
            value: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            title: title,
            systemImage: imageName,
            onValueChange: valueChanged
        )
        
        let hostingView = HostingView(rootView: incrementControl)
        hostingView.layer.cornerRadius = Constants.radius
        return hostingView
    }
    
    func updateAdults(value: Int) {
        adultPicker.rootView = IncrementControl(
            value: value,
            minValue: 1,
            maxValue: 6,
            title: "Adults",
            systemImage: "person.fill",
            onValueChange: { [weak self] newValue in
                guard let self = self else { return }
                self.delegate?.didChangeAdults(self, value: newValue)
            }
        )
    }
    
    func updateTeens(value: Int) {
        teenagerPicker.rootView = IncrementControl(
            value: value,
            minValue: 0,
            maxValue: 6,
            title: "Teens",
            systemImage: "figure.arms.open",
            onValueChange: { [weak self] newValue in
                guard let self = self else { return }
                self.delegate?.didChangeTeens(self, value: newValue)
            }
        )
    }

    func updateChildren(value: Int) {
        childrenPicker.rootView = IncrementControl(
            value: value,
            minValue: 0,
            maxValue: 6,
            title: "Children",
            systemImage: "figure.child",
            onValueChange: { [weak self] newValue in
                guard let self = self else { return }
                self.delegate?.didChangeChildren(self, value: newValue)
            }
        )
    }
}
