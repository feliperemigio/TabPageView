//
//  TabPageView.swift
//  HXP
//
//  Created by Felipe Remigio on 28/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

public protocol TabPageProtocol {
    var viewControllers: [UIViewController] {get set}
}

public class TabPageView: UIView, TabPageProtocol {
    
    private var tabPageViewController : TabPageViewController?
    public weak var delegate: TabPageViewDelegate?
    
    public var viewControllers: [UIViewController] = [] {
        didSet {
            self.tabPageViewController?.pages = self.viewControllers
        }
    }
    
    public var appearance: TabPageAppearance!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.appearance = TabPageAppearance(tabPageView: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
        self.appearance = TabPageAppearance(tabPageView: self)
    }
    
    private func setUp() {
        self.tabPageViewController = TabPageViewController()
        self.tabPageViewController?.delegate = self
        
        guard let view = self.tabPageViewController?.view else { return }
        
        self.addSubview(view)
        view.constraintToBounds(view: self)
    }
    
    func applyAppearance() {
        self.tabPageViewController?.applyAppearance(appearance: self.appearance)
    }
}

public protocol TabPageViewDelegate: AnyObject {
    func tabPageSlidingView(didSelectTabAt index: Int)
}


// MARK: - TabPageViewControllerDelegate

extension TabPageView: TabPageViewControllerDelegate {
    func tabPageViewController(didSelectTabAt index: Int) {
        self.delegate?.tabPageSlidingView(didSelectTabAt: index)
    }
}


// MARK: - Distribution

extension TabPageView {
    public enum Distribution {
        case fill
        case proportional
    }
}
