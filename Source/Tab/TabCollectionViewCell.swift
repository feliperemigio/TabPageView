//
//  TabCollectionViewCell.swift
//  HXP
//
//  Created by Felipe Remigio on 28/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

final class TabCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIView!
    
    private var tabBarItem: UITabBarItem?
    private var appearance: TabPageAppearance?
    
    private var textFont: UIFont? {
        self.tabBarItem?.titleTextAttributes(for: .normal)?[.font] as? UIFont
    }
    
    private var selectTextFont: UIFont? {
        self.tabBarItem?.titleTextAttributes(for: .selected)?[.font] as? UIFont
    }
    
    private var textColor: UIColor {
        self.tabBarItem?.titleTextAttributes(for: .normal)?[.strokeColor] as? UIColor ?? .gray
    }
    
    private var selectedTextColor: UIColor {
        self.tabBarItem?.titleTextAttributes(for: .selected)?[.strokeColor] as? UIColor ?? .blue
    }
    
    private var indicatorColor: UIColor {
        self.appearance?.indicatorColor ?? .blue
    }
    
    private var width: CGFloat = 0
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.font = self.isSelected ? self.selectTextFont : self.textFont
            UIView.animate(withDuration: 0.3) {
                
                self.indicatorView.backgroundColor = self.isSelected ? self.indicatorColor : .clear
                self.titleLabel.textColor = self.isSelected ? self.selectedTextColor : self.textColor
                self.titleLabel.font = self.isSelected ? self.selectTextFont : self.textFont
                self.titleLabel.adjustsFontSizeToFitWidth = true
                self.layoutIfNeeded()
            }
        }
    }
    
    func configure(tabBarItem: UITabBarItem?,
                   appearance: TabPageAppearance?,
                   width: CGFloat?) {
        self.appearance = appearance
        self.tabBarItem = tabBarItem
        self.titleLabel.text = tabBarItem?.title
        self.titleLabel.textColor = self.textColor
        self.titleLabel.font = self.textFont
        self.indicatorView.heightAnchor.constraint(equalToConstant: self.appearance?.indicatorHeight ?? 0).isActive = true
        self.width = width ?? 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size: CGSize = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = self.appearance?.distribution == .fill ? self.width : size.width
        var frame = layoutAttributes.frame
        frame.size.width = width
        self.titleLabel.preferredMaxLayoutWidth = width
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
