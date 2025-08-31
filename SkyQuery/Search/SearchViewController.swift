//
//  SearchViewController.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit
import Combine
import SwiftUI

class SearchViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let radius: CGFloat = 4
        static let height: CGFloat = 52
        static let verticalSpacing: CGFloat = 24
        static let margin: CGFloat = 16
        static let stackMargins: CGFloat = 32
        static let buttonBorderWidth: CGFloat = 1
        static let dateFormat: String = "yyyy-MM-dd"
    }
    
    // MARK: - Properties
    
    private let viewModel: SearchViewModel
    private weak var coordinator: SearchCoordinatorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    private var stationsHeightConstraint = NSLayoutConstraint()
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isUserInteractionEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stationsComponent: StationsComponent = {
        let component = StationsComponent()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    private lazy var datePickerView: FlightDatePicker = {
        let picker = FlightDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var incrementPickerStack: IncrementPickerStack = {
        let stack = IncrementPickerStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("search_flight", comment: ""), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .appYellow
        button.isEnabled = false
        button.layer.cornerRadius = Constants.radius
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.accessibilityIdentifier = "searchButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: SearchViewModel, coordinator: SearchCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        self.coordinator?.delegate = self
        self.viewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()

        bindViewModel()
        
        Task {
            do {
                try await viewModel.fetchStations()
            } catch {
                DispatchQueue.main.async {
                    self.coordinator?.showToaster()
                }
            }
        }
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .appBlue
        
        stationsComponent.delegate = self
        incrementPickerStack.delegate = self
        datePickerView.delegate = self
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        
        view.addSubview(scrollView)
        view.addSubview(searchButton)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(stationsComponent)
        stackView.addArrangedSubview(datePickerView)
        stackView.addArrangedSubview(incrementPickerStack)
        
        let fittingSize = stationsComponent.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width - 32, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        stationsHeightConstraint = stationsComponent.heightAnchor.constraint(equalToConstant: fittingSize.height)
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -Constants.margin),
            
            // Stack View
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.margin),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.margin),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.margin),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.margin),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Constants.stackMargins),
            
            stationsHeightConstraint,
            
            datePickerView.heightAnchor.constraint(equalToConstant: Constants.height),
            
            // Search Button
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.margin),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
        
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
    }
    
    private func bindViewModel() {
        viewModel.$arrivalStations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stations in
                self?.stationsComponent.setArrivalStations(stations)
            }
            .store(in: &cancellables)
        
        viewModel.$departureStations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stations in
                self?.stationsComponent.setDepartureStations(stations)
            }
            .store(in: &cancellables)
        
        viewModel.$parameters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] parameters in
                guard let self = self else { return }
                
                self.coordinator?.updateClearButtonColor(hasParameters: parameters.hasParameters)
                
                self.searchButton.backgroundColor = self.viewModel.searchButtonIsEnabled() ? .appYellow : .systemGray
                
                self.searchButton.isEnabled = self.viewModel.searchButtonIsEnabled()
                self.stationsComponent.setDeparture(parameters.origin)
                self.stationsComponent.setArrival(parameters.destination)
                
                self.datePickerView.setDate(parameters.dateOut)
                
                self.incrementPickerStack.updateAdults(value: parameters.adults ?? 1)
                self.incrementPickerStack.updateTeens(value: parameters.teens ?? 0)
                self.incrementPickerStack.updateChildren(value: parameters.children ?? 0)
                
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func searchButtonTapped() {
        Task {
            do {
                self.coordinator?.showLoading()
                let flights = try await viewModel.fetchFlights()
                coordinator?.hideLoading()
                coordinator?.showResults(flights: flights)
            } catch {
                coordinator?.hideLoading()
                coordinator?.showToaster()
            }
        }
    }
}

extension SearchViewController: SearchCoordinatorDelegate {
    func didTapCleanParameters() {
        viewModel.clearParameters()
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func viewModel(_: SearchViewModel, didUpdateParameters isUpdated: Bool) {
        DispatchQueue.main.async {
            self.coordinator?.showToaster(NSLocalizedString("error_same_origin_destination", comment: ""), toasterType: .error)
        }
    }
}

extension SearchViewController: FlightDatePickerDelegate {
    func flightDatePicker(_ datePicker: FlightDatePicker, didFinishFor textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func flightDatePicker(_ datePicker: FlightDatePicker, didPick date: Date, for textField: UITextField) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let stringDate = formatter.string(from: date)
        
        textField.text = stringDate
        viewModel.setDepartureDate(stringDate)
    }
}

extension SearchViewController: IncrementPickerStackDelegate {
    func didChangeAdults(_ view: IncrementPickerStack, value: Int) {
        viewModel.setAdults(adults: value)
    }
    
    func didChangeTeens(_ view: IncrementPickerStack, value: Int) {
        viewModel.setTeenagers(teenagers: value)
    }
    
    func didChangeChildren(_ view: IncrementPickerStack, value: Int) {
        viewModel.setChildren(children: value)
    }
}

extension SearchViewController: StationsComponentDelegate {
    
    func stationsComponentDidTapSwap(_ component: StationsComponent) {
        viewModel.switchOriginAndDestination()
    }
    
    func stationsComponent(_ component: StationsComponent, didChangeHeight height: CGFloat) {
        let fittingHeight = max(height, 120)
        if stationsHeightConstraint.constant != fittingHeight {
            stationsHeightConstraint.constant = fittingHeight
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func stationsComponent(_ component: StationsComponent,
                             didSelect station: Station,
                             for field: UITextField,
                           type: StationType) {
        let didSetStation: Bool
        
        switch type {
        case .arrival:
            didSetStation = viewModel.setArrivalStation(station)
        case .departure:
            didSetStation = viewModel.setDepartureStation(station)
        }
        
        if didSetStation { field.text = station.stationString }
            field.resignFirstResponder()
        }

    }
