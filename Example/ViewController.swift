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
        let viewController = UIViewController()
        viewController.tabBarItem = UITabBarItem()
        viewController.tabBarItem.title = "Teste"
        viewController.tabBarItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 30),
            .strokeColor: UIColor.red
        ], for: .normal)
        viewController.tabBarItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 40),
            .strokeColor: UIColor.black
        ], for: .selected)
        viewController.view.backgroundColor = .gray
        let viewController2 = UIViewController()
        viewController2.tabBarItem = UITabBarItem()
        viewController2.tabBarItem.title = "Teste 2"
        viewController2.view.backgroundColor = .yellow
        
        tabPageView.viewControllers = [viewController, viewController2]
        tabPageView.appearance.distribution = .fill
        tabPageView.appearance.backgroundColor = .white
        tabPageView.appearance.indicatorColor = .orange
        tabPageView.appearance.indicatorHeight = 2
    }


}

