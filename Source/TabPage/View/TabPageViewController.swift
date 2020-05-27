//
//  TabPageViewController.swift
//  HXP
//
//  Created by Felipe Remigio on 13/08/19.
//  Copyright © 2019 Vega I.T. All rights reserved.
//

import UIKit

class TabPageViewController: UIViewController {
    
    @IBOutlet private weak var tabCollectionView: UICollectionView!
    weak var delegate: TabPageViewControllerDelegate?
    private var pageViewController: UIPageViewController!
    
    @IBInspectable var tabBackgroundColor: UIColor = .black { didSet { self.tabCollectionView.backgroundColor = self.tabBackgroundColor } }
    @IBInspectable var tabTintColor: UIColor = .white { didSet { self.tabCollectionView.reloadData() } }
    @IBInspectable var tabTextColor: UIColor = .white { didSet { self.tabCollectionView.reloadData() } }
    var tabTextFont: UIFont = .systemFont(ofSize: 12) { didSet { self.tabCollectionView.reloadData() } }
    var tabSelectedTextFont: UIFont = .systemFont(ofSize: 12) { didSet { self.tabCollectionView.reloadData() } }
    var tabIndicatorHeight: CGFloat = 0 { didSet { self.tabCollectionView.reloadData() } }
    var sizeTabItem: CGSize? = nil
    var tabContentStyle: TabPageView.TabContentStyle = .fill {
        didSet {
            switch self.tabContentStyle {
            case .proportional:
                self.sizeTabItem = nil
            case .fill:
                self.sizeTabItem = CGSize(width: self.tabCollectionView.frame.width / CGFloat(pages.count), height: self.tabCollectionView.frame.height)
            }
            
            OperationQueue.main.addOperation {
                self.tabCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    var pages: [UIViewController] = [] {
        didSet {
            guard let page = self.pages.first else {
                return
            }
            
            self.tabCollectionView.reloadData()
            self.pageViewController.setViewControllers([page], direction: .forward, animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.selectTab(0) }
        }
    }
    
    private var currentIndex: Int = -1
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let podBundle = Bundle(for: Self.classForCoder())
        let bundleURL = podBundle.url(forResource: "TabPageView", withExtension: "bundle")!
        let bundle = Bundle(url: bundleURL)!
        super.init(nibName: nibNameOrNil, bundle: bundle)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    private func setUp() {
        self.setUpPageViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabCollectionView.register(TabCollectionViewCell.self)
        self.tabEstimatedItemSize()
    }

    private func setUpPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
         self.pageViewController.view.backgroundColor = .clear
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.view.constraintToBounds(view: self.view, topView: self.tabCollectionView)
    }
    
    private func tabEstimatedItemSize() {
        guard  let layout = self.tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {  return }
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    private func selectTab(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.tabCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        self.tabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.currentIndex = index
        self.delegate?.tabPageViewController(didSelectTabAt: self.currentIndex)
    }
    
    private func didSelectTab(at index: Int) {
        guard  index != currentIndex else { return }
        
        if index > currentIndex {
            self.pageViewController.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
        }else {
            self.pageViewController.setViewControllers([self.pages[index]], direction: .reverse, animated: true, completion: nil)
        }

        self.currentIndex = index
        tabCollectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
        self.delegate?.tabPageViewController(didSelectTabAt: self.currentIndex)
    }
    
}

protocol TabPageViewControllerDelegate: AnyObject {
    func tabPageViewController(didSelectTabAt index: Int)
}

extension TabPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = self.pages.firstIndex(of: viewController) else { return nil }
        guard index > 0 else { return nil }
        index -= 1
        return self.pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = self.pages.firstIndex(of: viewController) else { return nil }
        guard index < self.pages.count - 1 else { return nil }
        
        index += 1
        return self.pages[index]
    }
}

extension TabPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else { return }
        guard let page = self.pageViewController.viewControllers?.first, let index =  self.pages.firstIndex(of: page) else { return }
        self.selectTab(index)
    }
}

extension TabPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tabCollectionView {
            
            guard let tabCollectionViewCell = self.tabCollectionView.dequeueReusableTabCell(title: self.pages[indexPath.item].tabBarItem.title,
                                                                                            textColor: self.tabTextColor,
                                                                                            textFont: self.tabTextFont,
                                                                                            selectedTextFont: self.tabSelectedTextFont,
                                                                                            indicatorColor: self.tabTintColor,
                                                                                            indicatorHeight: tabIndicatorHeight,
                                                                                            size:  CGSize(width: (self.tabCollectionView.frame.width * 0.85) / CGFloat(pages.count), height: self.tabCollectionView.frame.height),
                                                                                            indexPath: indexPath) else {
                return UICollectionViewCell()
            }
            
            return tabCollectionViewCell
        }
        
        return UICollectionViewCell()
    }
    
}

extension TabPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectTab(at: indexPath.item)
    }
}


