//
//  StationsComponent.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import UIKit
import SwiftUI

enum StationType {
    case departure
    case arrival
}

protocol StationsComponentDelegate: AnyObject {
    func stationsComponentDidTapSwap(_ component: StationsComponent)
    func stationsComponent(_ component: StationsComponent,
                           didSelect station: Station, for field: UITextField,
                          type: StationType)
    func stationsComponent(_ component: StationsComponent, didChangeHeight height: CGFloat)
}

class StationsComponent: UIView {
    weak var delegate: StationsComponentDelegate?
    

    // MARK: - Constants
    
    private enum Constants {
        static let maxTableViewHeight: CGFloat = 360
        static let minTableViewHeight: CGFloat = 0
        static let radius: CGFloat = 4
        static let stackSpacing: CGFloat = 24
        static let verticalSpacing: CGFloat = 8
        static let fieldHeight: CGFloat = 52
    }
    
    private var filteredDepartStations: [Station] = []
    private var filteredArrivalStations: [Station] = []

        
    private var selectedStations: (depart: Station?, arrival: Station?) = (depart: nil, arrival: nil)
    
    private var departureStations: [Station] = [] {
        didSet {
            reloadTableViews()
        }
    }
    
    private var arrivalStations: [Station] = [] {
        didSet {
            reloadTableViews()
        }
    }
    
    private var searchDepartText: String = "" {
        didSet {
            debounceReload()
        }
    }

    private var searchArrivalText: String = "" {
        didSet {
            debounceReload()
        }
    }

    private var debounceWorkItem: DispatchWorkItem?

    private func debounceReload(delay: TimeInterval = 0.25) {
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.updateFilteredStations()
        }

        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    @objc private func reloadDepartureTable() {
        departureStationTableView.reloadData()
        updateTableViewHeights()
    }
    
    private var departureSearchHeightConstraint = NSLayoutConstraint()
    private var arrivalSearchHeightConstraint = NSLayoutConstraint()
    
    // MARK: - UI Components
    private lazy var departureTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search Departure Stations"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = Constants.radius
        textField.layer.masksToBounds = true
        textField.setLeftIcon(named: "airplane.departure", tintColor: .systemBlue)
        textField.setPlaceholderColor(.gray)
        textField.addTarget(self, action: #selector(departureTextChanged(_:)), for: .editingChanged)
        textField.delegate = self
        textField.accessibilityIdentifier = "departureSearchTextField"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var arrivalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search Arrival Stations"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = Constants.radius
        textField.layer.masksToBounds = true
        textField.setLeftIcon(named: "airplane.arrival", tintColor: .systemBlue)
        textField.setPlaceholderColor(.gray)
        textField.accessibilityIdentifier = "arrivalSearchTextField"
        textField.addTarget(self, action: #selector(arrivalTextChanged(_:)), for: .editingChanged)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var departureStationTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.radius
        tableView.register(UIHostingTableViewCell.self, forCellReuseIdentifier: "departureStationCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var arrivalStationTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.radius
        tableView.register(UIHostingTableViewCell.self, forCellReuseIdentifier: "arrivalStationCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var swapImage: UIView = {
        let view = UIHostingController(
            rootView: SwapImageView(onTap: { [weak self] in
                self?.swapButtonTapped()
            })
        ).view ?? UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        
        let departureStack = UIStackView(arrangedSubviews: [departureTextField, departureStationTableView])
        departureStack.axis = .vertical
        departureStack.spacing = Constants.verticalSpacing
        
        let arrivalStack = UIStackView(arrangedSubviews: [arrivalTextField, arrivalStationTableView])
        arrivalStack.axis = .vertical
        arrivalStack.spacing = Constants.verticalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [departureStack, swapImage, arrivalStack])
        mainStack.axis = .vertical
        mainStack.spacing = Constants.stackSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        departureSearchHeightConstraint = departureStationTableView.heightAnchor.constraint(equalToConstant: Constants.minTableViewHeight)
        departureSearchHeightConstraint.priority = .defaultLow
        arrivalSearchHeightConstraint = arrivalStationTableView.heightAnchor.constraint(equalToConstant: Constants.minTableViewHeight)
        arrivalSearchHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            departureTextField.heightAnchor.constraint(equalToConstant: Constants.fieldHeight),
            arrivalTextField.heightAnchor.constraint(equalToConstant: Constants.fieldHeight),
                    
            departureSearchHeightConstraint,
            arrivalSearchHeightConstraint,
            
            swapImage.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
        ])
    }
    
    private func updateTableViewHeights() {
        let maxHeight: CGFloat = Constants.maxTableViewHeight

        departureStationTableView.layoutIfNeeded()
        arrivalStationTableView.layoutIfNeeded()

        var departureHeight: CGFloat = Constants.minTableViewHeight
        var arrivalHeight: CGFloat = Constants.minTableViewHeight

        if departureTextField.isFirstResponder {
            departureHeight = min(departureStationTableView.contentSize.height, maxHeight)
        } else if arrivalTextField.isFirstResponder {
            arrivalHeight = min(arrivalStationTableView.contentSize.height, maxHeight)
        }

        departureSearchHeightConstraint.constant = departureHeight
        arrivalSearchHeightConstraint.constant = arrivalHeight

        let textFieldsHeight = Constants.fieldHeight * 2
        let tablesHeight = departureHeight + arrivalHeight
        let spacing = Constants.stackSpacing * 2
        let swapImageHeight = swapImage.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        let totalHeight = textFieldsHeight + tablesHeight + spacing + swapImageHeight

        delegate?.stationsComponent(self, didChangeHeight: totalHeight)

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

    private func updateFilteredStations() {
        if searchDepartText.isEmpty {
            filteredDepartStations = departureStations
        } else {
            filteredDepartStations = departureStations.filter {
                $0.stationString?.lowercased().contains(searchDepartText.lowercased()) ?? false
            }
        }

        if searchArrivalText.isEmpty {
            filteredArrivalStations = arrivalStations
        } else {
            filteredArrivalStations = arrivalStations.filter {
                $0.stationString?.lowercased().contains(searchArrivalText.lowercased()) ?? false
            }
        }

        reloadTableViews()
    }

    
    // MARK: - Actions
    @objc private func departureTextChanged(_ sender: UITextField) {
        searchDepartText = sender.text ?? ""
    }
    
    @objc private func arrivalTextChanged(_ sender: UITextField) {
        searchArrivalText = sender.text ?? ""
    }
    
    @objc private func swapButtonTapped() {
        delegate?.stationsComponentDidTapSwap(self)
    }
    
    // MARK: - Public Methods
    func setDepartureStations(_ stations: [Station]) {
        departureStations = stations
    }
    
    func setArrivalStations(_ stations: [Station]) {
        arrivalStations = stations
    }
    
    func setDeparture(_ station: Station?) {
        departureTextField.text = station?.stationString
        selectedStations.depart = station
        reloadTableViews()

    }
    
    func setArrival(_ station: Station?) {
        arrivalTextField.text = station?.stationString
        selectedStations.arrival = station
        reloadTableViews()
    }
    
    func setDeparturePlaceholder(_ text: String) {
        departureTextField.placeholder = text
    }
    
    func setArrivalPlaceholder(_ text: String) {
        arrivalTextField.placeholder = text
    }
    
    func reloadTableViews() {
        departureStationTableView.reloadData()
        arrivalStationTableView.reloadData()
        updateTableViewHeights()
    }
    
}

// MARK: - UITableViewDataSource and Delegate
extension StationsComponent: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == departureStationTableView {
            return filteredDepartStations.count
        } else {
            return filteredArrivalStations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = tableView == departureStationTableView ? "departureStationCell" : "arrivalStationCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UIHostingTableViewCell else {
            return UITableViewCell()
        }

        let station: Station
        let isSelected: Bool

        if tableView == departureStationTableView {
            station = filteredDepartStations[indexPath.row]
        } else {
            station = filteredArrivalStations[indexPath.row]
        }

        isSelected = station.code == selectedStations.depart?.code || station.code == selectedStations.arrival?.code
        cell.cellType = .stationsCellView(station: StationCellData(station: station, isSelected: isSelected))
        cell.uiTableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station: Station
        let textField: UITextField
        let type: StationType

        if tableView == departureStationTableView {
            station = filteredDepartStations[indexPath.row]
            textField = departureTextField
            type = .departure
        } else {
            station = filteredArrivalStations[indexPath.row]
            textField = arrivalTextField
            type = .arrival
        }

        delegate?.stationsComponent(self, didSelect: station, for: textField, type: type)
        updateTableViewHeights()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate
extension StationsComponent: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFilteredStations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTableViewHeights()
    }
}
