//
//  MainTabBarController.swift
//  HumanApps_Tech
//
//  Created by Глеб Клыга on 12.08.24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup Methods
    
    private func setupTabBar() {
        setupTabBarAppearance()
        setupViewControllers()
        addBorderAboveTabBar()
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupViewControllers() {
        let homeVC = createViewController(MainViewController(), title: "Home", image: UIImage(systemName: "scribble.variable"))
        let settingsVC = createViewController(SettingsViewController(), title: "Settings", image: UIImage(systemName: "scribble.variable"))
        
        viewControllers = [homeVC, settingsVC]
    }
    
    private func createViewController(_ viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func addBorderAboveTabBar() {
        let borderView = UIView()
        borderView.backgroundColor = .lightGray
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
