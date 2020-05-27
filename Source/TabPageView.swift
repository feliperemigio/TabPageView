//
//  TabPageView.swift
//  HXP
//
//  Created by Felipe Remigio on 13/08/19.
//  Copyright © 2019 Vega I.T. All rights reserved.
//

import UIKit

public protocol TabPageProtocol {
    var viewControllers: [UIViewController] {get set}
}

public class TabPageView: UIView, TabPageProtocol {
    
    public var viewControllers: [UIViewController] = [] {
        didSet { self.tabPageViewController?.pages = self.viewControllers }
    }
    
    private var tabPageViewController : TabPageViewController?
    
    @IBInspectable public var tabBackgroundColor: UIColor = .black {
        didSet { self.tabPageViewController?.tabBackgroundColor = self.tabBackgroundColor }
    }
    
    @IBInspectable public var tabTintColor: UIColor = .white {
        didSet { self.tabPageViewController?.tabTintColor = self.tabTintColor }
    }
    
    @IBInspectable public var tabTextColor: UIColor = .white {
        didSet { self.tabPageViewController?.tabTextColor = self.tabTextColor }
    }
    
    public var tabTextFont: UIFont = .systemFont(ofSize: 12) {
        didSet { self.tabPageViewController?.tabTextFont = self.tabTextFont }
    }
    
    public var tabSelectedTextFont: UIFont = .systemFont(ofSize: 12) {
        didSet { self.tabPageViewController?.tabSelectedTextFont = self.tabSelectedTextFont }
    }
    
    @IBInspectable public var tabIndicatorHeight: CGFloat = 2 {
        didSet { self.tabPageViewController?.tabIndicatorHeight = self.tabIndicatorHeight }
    }
    
    weak var delegate: TabPageSlidingViewDelegate?
    
    var tabContentStyle: TabContentStyle = .fill {
        didSet {self.tabPageViewController?.tabContentStyle = self.tabContentStyle}
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    private func setUp() {
        self.tabPageViewController = TabPageRouter.createModule()
        self.tabPageViewController?.delegate = self
        
        guard let view = self.tabPageViewController?.view else {
            return
        }
        
        self.addSubview(view)
        view.constraintToBounds(view: self)
    }
}

protocol TabPageSlidingViewDelegate: AnyObject {
    func tabPageSlidingView(didSelectTabAt index: Int)
}

extension TabPageView: TabPageViewControllerDelegate {
    func tabPageViewController(didSelectTabAt index: Int) {
        self.delegate?.tabPageSlidingView(didSelectTabAt: index)
    }
}

extension TabPageView {
    enum TabContentStyle {
        case fill
        case proportional
    }
}
