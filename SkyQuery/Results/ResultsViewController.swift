//
//  ResultsViewController.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit
import SwiftUI
import Combine

class ResultsViewController: UIViewController {
        
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: ResultsViewModel
    private weak var coordinator: ResultsCoordinatorProtocol?

    private lazy var flightsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UIHostingTableViewCell.self, forCellReuseIdentifier: "FlightHostingCell")
        tableView.accessibilityIdentifier = "FlightsResultsTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var noFlightsLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "No Flights found"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ResultsViewModel, coordinator: ResultsCoordinatorProtocol?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightsTableView.dataSource = self
        flightsTableView.delegate = self
        
        bindViewModel()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        view.backgroundColor = .appBlue

        view.addSubview(flightsTableView)
        view.addSubview(noFlightsLabel)

        NSLayoutConstraint.activate([
            flightsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flightsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flightsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flightsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noFlightsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFlightsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func bindViewModel() {
        viewModel.$flights
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flights in
                self?.noFlightsLabel.isHidden = !(flights ?? []).isEmpty
                self?.flightsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.flights ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = viewModel.flights?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightHostingCell", for: indexPath) as! UIHostingTableViewCell
        
        let flightCellData = FlightCellData(trip: trip, currency: viewModel.currency)
        
        cell.cellType = .flightsCellView(flight: flightCellData)
        cell.uiTableViewCell()
        
        return cell
    }
}

extension ResultsViewController: UITableViewDelegate {
    //TODO: finish
}
