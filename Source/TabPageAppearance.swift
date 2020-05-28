//
//  TabAppearance.swift
//  TabPageView
//
//  Created by Felipe Remigio on 28/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import UIKit

public final class TabPageAppearance {
    
    public var tabHeight: CGFloat = 50 {
        didSet {
            self.tabPageView.applyAppearance()
        }
    }
    
    public var backgroundColor: UIColor = .blue {
        didSet {
            self.tabPageView.applyAppearance()
        }
    }
    
    public var indicatorColor: UIColor? {
        didSet {
            self.tabPageView.applyAppearance()
        }
    }
    
    public var indicatorHeight: CGFloat = 0 {
        didSet {
            self.tabPageView.applyAppearance()
        }
    }
    
    public var distribution: TabPageView.Distribution = .fill {
        didSet {
            self.tabPageView.applyAppearance()
        }
    }
    
    private(set) unowned var tabPageView: TabPageView
    
    init(tabPageView: TabPageView) {
        self.tabPageView = tabPageView
    }
}
