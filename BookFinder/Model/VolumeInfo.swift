//
//  VolumeInfo.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import Foundation

struct VolumeInfo: Codable{
    let title: String
    let subtitle:String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let language: String
    let previewLink:String?
    let infoLink:String
}
