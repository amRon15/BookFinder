//
//  SceneDelegate.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabbar()
        window?.makeKeyAndVisible()
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            // 嘗試恢復之前的登錄狀態
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                if let user = user {
                    let authToken = user.accessToken.tokenString
                    // 儲存權杖到 GoogleSignInManager
                    NetworkManager.shared.userAuthToken = authToken
                    NetworkManager.shared.currentUser = user
                    // 設置主畫面（UITabBarController）
                    self?.window?.rootViewController = self?.tabbar()
                } else {
                    // 登錄失敗或無之前的登錄，顯示 LoginViewController
                    self?.window?.rootViewController = LoginViewController()
                }
                self?.window?.makeKeyAndVisible()
                self?.configureNavBar()
            }
        } else {
            // 無登錄記錄，顯示 LoginViewController
            window?.rootViewController = LoginViewController()
            window?.makeKeyAndVisible()
            configureNavBar()
        }                
    }
    
    func tabbar() -> UITabBarController{
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        tabbar.viewControllers = [searchNavigationController(), bookmarkNavigationController()]
        
        return tabbar
    }
    
    func searchNavigationController() -> UINavigationController{
        let searchNavigationController = SearchViewController()
        searchNavigationController.title = "Home"
        searchNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        return UINavigationController(rootViewController: searchNavigationController)
    }
    
    func bookmarkNavigationController() -> UINavigationController{
        let bookmarkNavigationController = BookmarkViewController()
        bookmarkNavigationController.title = "Bookmark"
        bookmarkNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        return UINavigationController(rootViewController: bookmarkNavigationController)
    }
    
    func configureNavBar(){
        UINavigationBar.appearance().tintColor = UIColor.systemGreen
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

