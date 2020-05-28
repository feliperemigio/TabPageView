//
//  TabPageViewController.swift
//  HXP
//
//  Created by Felipe Remigio on 28/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

class TabPageViewController: UIViewController {
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    weak var delegate: TabPageViewControllerDelegate?
    
    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.backgroundColor = .clear
        return pageViewController
    }()
    
    private var widthTabItem: CGFloat? {
        guard self.appearance?.distribution == .fill else { return nil }
        return self.tabCollectionView.frame.width / CGFloat(pages.count)
    }
    
    var pages: [UIViewController] = [] {
        didSet {
            guard let page = self.pages.first else { return}
            
            self.tabCollectionView.reloadData()
            self.pageViewController.setViewControllers([page], direction: .forward, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.selectTab(0) }
        }
    }
    
    private var currentIndex: Int?
    
    private var appearance: TabPageAppearance?
    
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
        
        guard  let layout = self.tabCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {  return }
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private func setUpPageViewController() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.view.constraintToBounds(view: self.view, topView: self.tabCollectionView)
    }
    
    private func selectTab(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.tabCollectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .centeredHorizontally
        )
        
        self.tabCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        self.currentIndex = index
        self.delegate?.tabPageViewController(didSelectTabAt: self.currentIndex ?? 0)
    }
    
    private func didSelectTab(at index: Int) {
        guard  index != self.currentIndex else { return }
        
        if index > (self.currentIndex ?? 0) {
            self.pageViewController.setViewControllers(
                [ self.pages[index] ],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }else {
            self.pageViewController.setViewControllers(
                [self.pages[index]],
                direction: .reverse,
                animated: true,
                completion: nil
            )
        }

        self.currentIndex = index
        tabCollectionView.scrollToItem(
            at: IndexPath.init(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        self.delegate?.tabPageViewController(didSelectTabAt: self.currentIndex ?? 0)
    }
    
    func applyAppearance(appearance: TabPageAppearance) {
        self.appearance = appearance
        self.tabCollectionView.removeConstraints(self.tabCollectionView.constraints.filter { $0.firstAttribute == .height } )
        self.tabCollectionView.heightAnchor.constraint(equalToConstant: self.appearance?.tabHeight ?? 50).isActive = true
        self.tabCollectionView.backgroundColor = self.appearance?.backgroundColor
        self.tabCollectionView.reloadData()
    }
}

protocol TabPageViewControllerDelegate: AnyObject {
    func tabPageViewController(didSelectTabAt index: Int)
}


// MARK: - UIPageViewControllerDataSource

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


// MARK: - UIPageViewControllerDelegate

extension TabPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else { return }
        guard let page = self.pageViewController.viewControllers?.first,
            let index =  self.pages.firstIndex(of: page) else { return }
        self.selectTab(index)
    }
}


// MARK: - UICollectionViewDataSource

extension TabPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tabCollectionView {
            
            guard let tabCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TabCollectionViewCell.defaultReuseIdentifier,
                for: indexPath
                ) as? TabCollectionViewCell else { return UICollectionViewCell() }
            
            tabCollectionViewCell.configure(
                tabBarItem: self.pages[indexPath.item].tabBarItem,
                appearance: self.appearance,
                width: self.widthTabItem
            )
            
            return tabCollectionViewCell
        }
        
        return UICollectionViewCell()
    }
}

extension TabPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: collectionView.bounds.height)
    }
}


// MARK: - UICollectionViewDelegate

extension TabPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectTab(at: indexPath.item)
    }
}


