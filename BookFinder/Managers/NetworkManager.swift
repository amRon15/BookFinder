//
//  NetworkManager.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import Foundation

class NetworkManager{
    static let shared = NetworkManager()
    let baseURL = "https://www.googleapis.com/books/v1/"
        
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
}
