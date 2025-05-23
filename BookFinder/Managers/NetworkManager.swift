//
//  NetworkManager.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import Foundation
import GoogleSignIn

class NetworkManager{
    static let shared = NetworkManager()
    let baseURL = "https://www.googleapis.com/books/v1/"
            
    var userAuthToken: String?
        
    var currentUser: GIDGoogleUser?
    
    private init(){
        // Configure Google Sign In
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            print("Error: GIDClientID not found in Info.plist")
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        print("Google Sign In configured with client ID: \(clientID)")
    }
            
    func getBooks(_ name: String?, completion: @escaping (ResultItem?, String?) -> ()){
        guard let name = name else {
            completion(nil, "Invalid word")
            return
        }
        let endpoint = baseURL + "volumes?q=\(name)&printType=books"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil, "Unable to get magazines from internet. Please check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server. Please try again")
                return
            }
            
            guard let data = data else {
                completion(nil, "Failed to received data from the server. Please try again")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                completion(resultItem, nil)
            } catch{
                completion(nil, "Failed to received data from the server. Please try again")
            }
        }
        
        task.resume()
    }
    
    func getBooksByID(_ id: String, completion: @escaping (ResultItem?, String?) -> ()){
        let endpoint = baseURL + "volumes?q=\(id)&orderBy=newest"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil, "Unable to get books from internet. Please check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server. Please try again")
                return
            }
            
            guard let data = data else {
                completion(nil, "Failed to received data from the server. Please try again")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                completion(resultItem, nil)
            } catch{
                completion(nil, "Failed to received data from the server. Please try again")
            }
        }
        
        task.resume()
    }
    
    func getBooksByName(_ name: String, completion: @escaping (ResultItem?, String?) -> ()){
        let endpoint = baseURL + "volumes?q=\(name)&orderBy=newest"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil, "Unable to get books from internet. Please check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server. Please try again")
                return
            }
            
            guard let data = data else {
                completion(nil, "Failed to received data from the server. Please try again")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                completion(resultItem, nil)
            } catch{
                completion(nil, "Failed to received data from the server. Please try again")
            }
        }
        
        task.resume()
    }
    
    func getBooksByCategory(_ category: String, completion: @escaping (ResultItem?, String?) -> ()){
        let endpoint = baseURL + "volumes?q=subject:\(category)&orderBy=newest"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil, "Unable to get books from internet. Please check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server. Please try again")
                return
            }
            
            guard let data = data else {
                completion(nil, "Failed to received data from the server. Please try again")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                completion(resultItem, nil)
            } catch{
                completion(nil, "Failed to received data from the server. Please try again")
            }
        }
        
        task.resume()
    }
    
    func addBookToShelf(_ volumeID: String, completion: @escaping (Bool, String?) -> ()){
        guard let authToken = userAuthToken else {
            completion(false, "User not sign in")
            return
        }
        
        let endpoint = baseURL + "myLibrary/bookshelves/\(0)/addVolume?volumeId=\(volumeID)"
        guard let url = URL(string: endpoint) else {
            completion(false, "Invalid Url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                completion(false, "Failed to add book to bookshelves")
                return
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
    
    func getBookshelf(shelfId: String = "0", completion: @escaping (ResultItem?, Error?) -> Void) {
        guard let authToken = userAuthToken else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not signed in"])
            completion(nil, error)
            return
        }
        
        let urlString = "https://www.googleapis.com/books/v1/mylibrary/bookshelves/\(shelfId)/volumes"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                completion(resultItem, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func signInWithGoogle(_ viewController: UIViewController, completion: @escaping (Bool, String?) -> ()){
        guard (GIDSignIn.sharedInstance.configuration?.clientID) != nil else {
            print("Error: Google Sign In client ID is not configured")
            completion(false, "Google Sign In is not properly configured")
            return
        }
        
        print("Attempting to sign in with Google...")
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: nil) { [weak self] result, error in
            if let error = error {
                print("Google Sign In error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let result = result else {
                print("Google Sign In failed: No result returned")
                completion(false, "Sign in failed")
                return
            }
            
            print("Google Sign In successful")
            self?.currentUser = result.user
            self?.userAuthToken = result.user.accessToken.tokenString
            
            completion(true, nil)
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        userAuthToken = nil
        currentUser = nil
    }
}
