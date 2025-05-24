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
    private let baseURL = "https://www.googleapis.com/books/v1/"
            
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
    
    func getBooksByName(_ name: String, _ index: Int, completion: @escaping (ResultItem?, String?) -> ()){
        let endpoint = baseURL + "volumes?q=\(name)&maxResults=10&startIndex=\(index)&orderBy=newest"
        
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
    
    func getBooksByCategory(_ category: String, _ index: Int, completion: @escaping (ResultItem?, String?) -> ()){
        let endpoint = baseURL + "volumes?q=subject:\(category)&maxResults=10&startIndex=\(index)&orderBy=newest"
        
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
    
    func addBookToShelf(_ volumeID: String, completion: @escaping (Bool, String?) -> ()) {
        guard let authToken = userAuthToken else {
            completion(false, "User not signed in")
            return
        }
        
        let endpoint = baseURL + "mylibrary/bookshelves/0/addVolume?volumeId=\(volumeID)"
        guard let url = URL(string: endpoint) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response: No HTTP response")
                completion(false, "Invalid response from the server")
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            // Accept both 204 and 200 as success
            guard (200...204).contains(httpResponse.statusCode) else {
                completion(false, "Failed to add book to bookshelf. Status code: \(httpResponse.statusCode)")
                return
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
    
    func deleteBookmark(_ volumeID: String, completion: @escaping (Bool, String?) -> ()){
        guard let authToken = userAuthToken else {
            completion(false, "User not signed in")
            return
        }
        
        let endpoint = baseURL + "mylibrary/bookshelves/0/removeVolume?volumeId=\(volumeID)"
        guard let url = URL(string: endpoint) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response: No HTTP response")
                completion(false, "Invalid response from the server")
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            // Accept both 204 and 200 as success
            guard (200...204).contains(httpResponse.statusCode) else {
                completion(false, "Failed to add book to bookshelf. Status code: \(httpResponse.statusCode)")
                return
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
    
    func getBookshelf(completion: @escaping (ResultItem?, Error?) -> Void) {
        guard let authToken = userAuthToken else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not signed in"])
            completion(nil, error)
            return
        }

        let endpoint = baseURL + "mylibrary/bookshelves/0/volumes"
        guard let url = URL(string: endpoint) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response: No HTTP response")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from the server"]))
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
                print("Unexpected error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func isBookSaved(_ volumeId: String, completion: @escaping (Bool, String?) -> ()){
        guard let authToken = userAuthToken else {
            completion(false, "User not signed in")
            return
        }

        let endpoint = baseURL + "mylibrary/bookshelves/0/volumes"
        guard let url = URL(string: endpoint) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response: No HTTP response")
                completion(false, "Invalid response from the server")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(false, "Server returned status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let resultItem = try decoder.decode(ResultItem.self, from: data)
                
                // Check if the book exists in the bookshelf by looking at the items array
                let isSaved = resultItem.items?.contains { item in
                    item.id == volumeId
                } ?? false
                
                completion(isSaved, nil)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(false, "Failed to decode response")
            }
        }
        task.resume()
    }
    
    func signInWithGoogle(_ viewController: UIViewController, completion: @escaping (Bool, String?) -> ()) {
        guard (GIDSignIn.sharedInstance.configuration?.clientID) != nil else {
            print("Error: Google Sign In client ID is not configured")
            completion(false, "Google Sign In is not properly configured")
            return
        }
        
        print("Attempting to sign in with Google...")
        let scopes = ["https://www.googleapis.com/auth/books"]
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: nil, additionalScopes: scopes) { [weak self] result, error in
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
            
            let user = result.user
            let authToken = user.accessToken.tokenString
            
            print("Google Sign In successful")
            self?.currentUser = user
            self?.userAuthToken = authToken
            completion(true, nil)
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.disconnect { error in
            if let error = error {
                print("Error disconnecting Google Sign-In: \(error.localizedDescription)")
            } else {
                print("Successfully disconnected Google Sign-In")
            }
        }
        userAuthToken = nil
        currentUser = nil
    }
    
    func getUserInfo(completion: @escaping (User?, String?) -> ()){
        guard let currentUser = currentUser else {
            completion(nil, "No user is signed in")
            return
        }
        
        let profile = currentUser.profile
        var user = User(name: profile?.name ?? "Unknown", email: profile?.email ?? "No email")
        
        if let profile = profile, profile.hasImage {
            user.imageUrl = profile.imageURL(withDimension: 200)?.absoluteString
        }
        
        completion(user, nil)
    }
}
