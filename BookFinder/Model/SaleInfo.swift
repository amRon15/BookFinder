//
//  SaleInfo.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import Foundation

struct SaleInfo: Codable{
    let country: String
    let saleability: String
    let listPrice: Price?
    let retailPrice: Price?
}
