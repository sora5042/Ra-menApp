//
//  BaseTabBarViewController.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/03.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    
    enum ControllerName: Int {
        case home, search, post, profile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        viewControllers?.enumerated().forEach({ (index, viewController) in
            
            if let name = ControllerName.init(rawValue: index) {
                
                switch name {
                
                case .home:
                    setTabBarInfo(viewController, selectedImageName: "selectedラーメン", unselectedImageName: "unselectedラーメン", title: "ラーメン")
                case .search:
                    setTabBarInfo(viewController, selectedImageName: "selectedサーチ", unselectedImageName: "unselectedサーチ", title: "探す")
                case .post:
                    setTabBarInfo(viewController, selectedImageName: "selectedプラス", unselectedImageName: "unselectedプラス", title: "投稿")
                case .profile:
                    setTabBarInfo(viewController, selectedImageName: "profile", unselectedImageName: "unselectedProfile", title: "プロフィール")
                    
                }
            }
        })
    }
    
    private func setTabBarInfo(_ viewController: UIViewController, selectedImageName: String, unselectedImageName: String, title: String) {
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
    }
}
