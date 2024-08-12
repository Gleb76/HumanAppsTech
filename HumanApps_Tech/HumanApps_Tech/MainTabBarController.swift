//
//  MainTabBarController.swift
//  HumanApps_Tech
//
//  Created by Глеб Клыга on 12.08.24.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addBorderAboveTabBar()
        generateTabBar()
    }
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.gray
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: MainViewController(),
                title: "Home",
                image: UIImage(systemName: "scribble.variable")),
            generateVC(
                viewController: SettingsViewController(),
                title: "Settings",
                image: UIImage(systemName: "scribble.variable"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func addBorderAboveTabBar() {
        let borderView = UIView()
        borderView.backgroundColor =  UIColor.lightGray
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
