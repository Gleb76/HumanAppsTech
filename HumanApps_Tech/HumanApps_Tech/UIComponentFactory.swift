//
//  UIComponentFactory.swift
//  HumanApps_Tech
//
//  Created by Глеб Клыга on 12.08.24.
//

import UIKit

struct UIComponentFactory {
    
    static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.yellow.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func createSegmentedControl(items: [String]) -> UISegmentedControl {
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }
    
    static func createButton(title: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

