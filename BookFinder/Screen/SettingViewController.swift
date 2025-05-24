//
//  SettingViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 24/5/2025.
//

import UIKit

class SettingViewController: UIViewController {
    let logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemGreen
        configureLogoutButton()
    }
    
    func configureLogoutButton(){
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set button title and style
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        logoutButton.setTitleColor(.systemBlue, for: .normal)
        
        // Configure button appearance
        logoutButton.backgroundColor = .systemBackground
        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.masksToBounds = false
        logoutButton.clipsToBounds = false
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowRadius = 4
        
        // Add padding
        logoutButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func logout(){
        NetworkManager.shared.signOut()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = LoginViewController()
        }
    }

}
