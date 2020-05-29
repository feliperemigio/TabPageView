//
//  ViewController.swift
//  Example
//
//  Created by Felipe Remigio on 27/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import UIKit
import TabPageView

class ViewController: UIViewController {
    
    @IBOutlet weak var tabPageView: TabPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .strokeColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .strokeColor: UIColor.white
        ]
        
        let firstView = UIViewController()
        firstView.tabBarItem = UITabBarItem()
        firstView.tabBarItem.title = "First"
        firstView.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        firstView.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        firstView.view.backgroundColor = .gray
        
        let secondView = UIViewController()
        secondView.tabBarItem = UITabBarItem()
        secondView.tabBarItem.title = "Second"
        secondView.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        secondView.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        secondView.view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        
        tabPageView.viewControllers = [firstView, secondView]
        tabPageView.appearance.distribution = .proportional
        tabPageView.appearance.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        tabPageView.appearance.indicatorColor = .white
        tabPageView.appearance.indicatorHeight = 2
        tabPageView.appearance.tabHeight = 100
        tabPageView.delegate = self
        tabPageView.tabCollectionView?.contentInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        (tabPageView.tabCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 50
    }
}


extension ViewController: TabPageViewDelegate {
    func tabPageSlidingView(didSelectTabAt index: Int) {
        
    }
}
