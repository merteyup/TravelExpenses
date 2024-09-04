//
//  CityDetailViewController.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit
import SnapKit
import MapKit

class CityDetailViewController: UIViewController, CityDetailViewModelDelegate {
    
    var viewModel: CityDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private let tableView = UITableView()
    private let mapView = MKMapView()
    private var presentation: CityDetailPresentation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        configureTableView()
        setupConstraints()
    }
   
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(EmptyCell.self, 
                           forCellReuseIdentifier: "EmptyCell")
        tableView.register(CityDetailCell.self, 
                           forCellReuseIdentifier: "CityDetailCell")
        tableView.register(CityDetailHeaderCell.self, 
                           forCellReuseIdentifier: "CityDetailHeaderCell")
    }
    
    private func setupConstraints() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func showDetail(_ presentation: CityDetailPresentation) {
        self.presentation = presentation
        configureMapView(presentation)
    }
    
    private func configureMapView(_ presentation: CityDetailPresentation) {
        if let latitude = presentation.lat, let longitude = presentation.lng {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, 
                                                    longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = presentation.cityName
            
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, 
                                            latitudinalMeters: 20000,
                                            longitudinalMeters: 20000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func handleViewModelOutput(_ output: CityDetailViewModelOutput) {
        switch output {
        case .updateTitle(let string):
            title = string
        case .setLoading(let bool):
            bool ? view.showLoading() : view.hideLoading()
        case .showPriceDetails(_):
            tableView.reloadData()
            break
        }
    }
    
}

extension CityDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = presentation?.prices?.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityDetailCell", for: indexPath) as! CityDetailCell
            if let prices = presentation?.prices { cell.configure(withTitles: prices) }
            return cell
        } else {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            emptyCell.configure(with: "There's no info found. Check your internet connection or application usage limit.")
            tableView.separatorStyle = .none
            return emptyCell
        }
    }
}
