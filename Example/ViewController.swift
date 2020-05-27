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
        viewController.view.backgroundColor = .gray
        
        let viewController2 = UIViewController()
        viewController2.tabBarItem = UITabBarItem()
        viewController2.tabBarItem.title = "Teste 2"
        viewController2.view.backgroundColor = .yellow
        
        tabPageView.viewControllers = [viewController, viewController2]
        
    }


}

