//
//  ReusableView.swift
//  HXP
//
//  Created by Felipe Remigio on 13/08/19.
//  Copyright © 2019 Vega I.T. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String { return String(describing: self) }
}

public protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String { return String(describing: self) }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let podBundle = Bundle(for: T.classForCoder())
        let bundleURL = podBundle.url(forResource: "TabPageView", withExtension: "bundle")!
        let bundle = Bundle(url: bundleURL)!
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
}
