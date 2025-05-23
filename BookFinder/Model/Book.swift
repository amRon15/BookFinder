//
//  Book.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import Foundation

struct Book: Codable{
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    
    private enum CodingKeys: String, CodingKey {
        case id, selfLink, volumeInfo, saleInfo, accessInfo
    }
}
