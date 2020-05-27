//
//  TabCollectionViewCell.swift
//  HXP
//
//  Created by Felipe Remigio on 13/08/19.
//  Copyright © 2019 Vega I.T. All rights reserved.
//

import UIKit

final class TabCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorViewHeightConstraint: NSLayoutConstraint!
    
    private var indicatorColor: UIColor = UIColor.gray
    private var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    private var selectTextFont: UIFont = UIFont.systemFont(ofSize: 16)
    private var textColor: UIColor = .white
    private var size: CGSize? = nil
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.font = self.isSelected ? self.selectTextFont : self.textFont
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.backgroundColor = self.isSelected ? self.indicatorColor : .clear
                self.titleLabel.textColor = self.isSelected ? self.indicatorColor : self.textColor
                self.titleLabel.adjustsFontSizeToFitWidth = true
                self.layoutIfNeeded()
            }
        }
    }
    
    func configure(title: String?, textColor: UIColor, textFont: UIFont, selectedTextFont: UIFont, indicatorColor: UIColor?, indicatorHeight: CGFloat, size: CGSize?) {
        self.indicatorColor = indicatorColor ?? .gray
        self.titleLabel.text = title
        self.titleLabel.textColor = textColor
        self.titleLabel.font = textFont
        self.textFont = textFont
        self.selectTextFont = selectedTextFont
        self.textColor = textColor
        self.indicatorViewHeightConstraint.constant = indicatorHeight
        self.size = size
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size: CGSize = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = (self.size != nil) ? self.size!.width : size.width
        var frame = layoutAttributes.frame
        frame.size.width = width
        self.titleLabel.preferredMaxLayoutWidth = width
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
