//
//  RandomWordManager.swift
//  BookFinder
//
//  Created by 邱允聰 on 23/5/2025.
//

import Foundation

class RandomWordManager{
    static let shared = RandomWordManager()
    let baseUrl: String = "https://random-word-api.herokuapp.com/word?length="
    
    func getRandomWord(completion: @escaping (String?, String?) -> ()){
        let randomInt = Int.random(in: 5...12)
        let endpoint = baseUrl + "\(randomInt)"
        
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
                let randomWord = try decoder.decode([String].self, from: data).first
                print(randomWord)
                completion(randomWord, nil)
            } catch{
                completion(nil, "Failed to received data from the server. Please try again")
            }
        }
        
        task.resume()
    }
}
