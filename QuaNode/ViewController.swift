//
//  ViewController.swift
//  QuaNode
//
//  Created by Gado on 8/4/19.
//  Copyright © 2019 Gado. All rights reserved.
//


import UIKit
import Parchment
import ObjectMapper

var cities = [City]()
var isSearching = false

class ViewController: UIViewController {
    @IBOutlet weak var citiesSearchBar: UISearchBar!
    var countryCities = [City]()
    var currentViewController: CountryViewController?
    var countries = [String]()
    var uniqueCountries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureJsonFile()
        configurePagingViewController()
        
    }
    
    
    func configureJsonFile()  {
        
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            
            
            
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            let jsonCities = Mapper<City>().mapArray(JSONArray: json as! [[String : Any]])
            
            for city in jsonCities{
                cities.append(city)
                countries.append(city.country!)
                
            }
            
        }
        catch {
            print(error)
        }
        uniqueCountries = countries.unique()
        
    }
    
    func configurePagingViewController()  {
        
        let pagingViewController = PagingViewController<PagingIndexItem>()
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        
        // Add the paging view controller as a child view controller and
        // contrain it to all edges.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToSearchField(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
}

extension ViewController: PagingViewControllerDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        if (index == 0)
        {
            return PagingIndexItem(index: index, title: "ALL") as! T
        } else {
            
            return PagingIndexItem(index: index, title: uniqueCountries[index - 1]) as! T
            
        }
        
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        if (index == 0)
        {
            let controller = CountryViewController(title: "ALL")
            currentViewController = controller
            return controller
        } else {
            
            return CountryViewController(title: uniqueCountries[index - 1])
            
        }
        
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return uniqueCountries.count + 1
    }
    
}

extension ViewController: PagingViewControllerDelegate {
    
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? {
        guard let item = pagingItem as? PagingIndexItem else { return 0 }
        
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
        let attributes = [NSAttributedString.Key.font: pagingViewController.font]
        
        let rect = item.title.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
        
        let width = ceil(rect.width) + insets.left + insets.right
        
        if isSelected {
            
            return width * 1.5
        } else {
            return width
        }
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        currentViewController = destinationViewController as? CountryViewController
        
    }
}

extension ViewController : UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""
        {
            isSearching = false
            view.endEditing(true)
            
        } else
        {
            isSearching = true
            currentViewController?.filteredCountryCities = currentViewController?.countryCities.filter({($0.name?.lowercased().contains(searchBar.text!.lowercased()))! } ) ?? []
            self.reload()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
            
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    @objc func reload() {
        currentViewController?.myTableView.reloadData()
    }
    
}


