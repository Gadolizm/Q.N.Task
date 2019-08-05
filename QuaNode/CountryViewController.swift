//
//  CityViewController.swift
//  QuaNode
//
//  Created by Gado on 8/4/19.
//  Copyright © 2019 Gado. All rights reserved.
//

import UIKit
import MapKit


class CountryViewController: UIViewController {
    
    var myTableView: UITableView!
    var countryCities = [City]()
    var filteredCountryCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCityArray()

    }
 
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
        label.text = title
        label.sizeToFit()
        
        view.addSubview(label)
        view.constrainCentered(label)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCityArray()  {
        
        
        for city in cities
        {
            if city.country! == self.title!
            {
                countryCities.append(city)
            }
            else if city.country! != self.title! && self.title == "ALL"
            {
                countryCities.append(city)
            }
        }
    }
}


extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func configureTableView()  {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight ))
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching
        {
            getDirection(latitude: Double(filteredCountryCities[indexPath.row].latitude!) as! Double, longitude:  Double(filteredCountryCities[indexPath.row].longitude!) as! Double)
        }
        else
        {
            getDirection(latitude: Double(countryCities[indexPath.row].latitude!) as! Double, longitude:  Double(countryCities[indexPath.row].longitude!) as! Double)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching
        {
            return filteredCountryCities.count
        }else{
            return countryCities.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        if isSearching
        {
            cell.textLabel!.text = "\(filteredCountryCities[indexPath.row].name!)"
            //        print(ViewController.cities[indexPath.row].name!)
            return cell
        }
        else
        {
            cell.textLabel!.text = "\(countryCities[indexPath.row].name!)"
            return cell
        }
    }
    
    
    func getDirection(latitude: Double, longitude: Double)  {
        
        let latitude:CLLocationDegrees = latitude
        let longitude:CLLocationDegrees = longitude
        
        let regionDistance : CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey : NSValue (mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey : NSValue (mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.openInMaps(launchOptions: options)
  
    }
    
}
