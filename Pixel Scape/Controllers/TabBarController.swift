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
        let home = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let liked = storyboard.instantiateViewController(withIdentifier: "LikedViewController")

        home.tabBarItem = UITabBarItem(title: "Pixel", image: UIImage(systemName: "photo.circle.fill"), selectedImage: UIImage(systemName: "photo.circle.fill"))
        liked.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart.circle.fill"), selectedImage: UIImage(systemName: "heart.circle.fill"))

        self.viewControllers = [home, liked]
}

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true
    }
}

