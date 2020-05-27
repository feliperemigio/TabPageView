//
//  TabPageRouter.swift
//  HXP
//
//  Created by Felipe Remigio on 13/08/19.
//  Copyright © 2019 Vega I.T. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableTabCell(title: String?, textColor: UIColor, textFont: UIFont, selectedTextFont: UIFont, indicatorColor: UIColor?, indicatorHeight: CGFloat, size: CGSize?, indexPath: IndexPath) -> TabCollectionViewCell? {
        let tabCollectionViewCell =  self.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? TabCollectionViewCell
        tabCollectionViewCell?.configure(title: title, textColor: textColor, textFont: textFont, selectedTextFont: selectedTextFont, indicatorColor: indicatorColor, indicatorHeight: indicatorHeight, size: size)
        return tabCollectionViewCell
    }
}

