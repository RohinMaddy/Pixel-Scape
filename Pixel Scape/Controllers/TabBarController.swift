//
//  TabBarController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 16/04/2025.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let item1 = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            item1.tabBarItem = UITabBarItem(title: "Pixel", image: UIImage(systemName: "photo.circle.fill"), selectedImage: UIImage(systemName: "photo.circle.fill"))
            
            if let item2 = storyboard.instantiateViewController(withIdentifier: "LikedViewController") as? LikedViewController {
                item2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "heart.circle.fill"), selectedImage: UIImage(systemName: "heart.circle.fill"))
                
                self.viewControllers = [item1, item2]
            } else {
                self.viewControllers = [item1]
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true
    }
}

