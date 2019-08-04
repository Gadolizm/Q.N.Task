//
//  ViewController.swift
//  QuaNode
//
//  Created by Gado on 8/4/19.
//  Copyright © 2019 Gado. All rights reserved.
//


import UIKit
import Parchment

class ViewController: UIViewController {
    
    @IBOutlet weak var citiesSearchBar: UISearchBar!
    // Let's start by creating an array of citites that we
    // will use to generate some view controllers.
    fileprivate let countries = [
        "Oslo",
        "Stockholm",
        "Tokyo",
        "Barcelona",
        "Vancouver",
        "Berlin",
        "Shanghai",
        "London",
        "Paris",
        "Chicago",
        "Madrid",
        "Munich",
        "Toronto",
        "Sydney",
        "Melbourne"
    ]
    var country = [String]()
    var uniqueCountries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //                print(json)
            //
            //                guard let array = json as? [String: Any] else { return }
            //
            //
            //                    print(array)
            
            guard let cities = json as? [[String: Any]] else {
                return
            }
            //                "name": "Pas de la Casa",
            //                "lat": "42.54277",
            //                "lng": "1.73361"
            
            for dic in cities{
                country.append(dic["country"] as! String)
                //                    print(country) //Output
            }
            //
            
            
            
        }
        catch {
            print(error)
        }
        uniqueCountries = country.unique()
        
        
        
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
            return CountryViewController(title: "ALL")
        } else {
            
            return CountryViewController(title: uniqueCountries[index - 1])
            
        }
        
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        print(uniqueCountries.count)
        return uniqueCountries.count + 1
    }
    
}

extension ViewController: PagingViewControllerDelegate {
    
    // We want the size of our paging items to equal the width of the
    // city title. Parchment does not support self-sizing cells at
    // the moment, so we have to handle the calculation ourself. We
    // can access the title string by casting the paging item to a
    // PagingTitleItem, which is the PagingItem type used by
    // FixedPagingViewController.
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
    
}



