//
//  MovieListModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

struct HomeSeriesListModel: Codable {
    let show: ShowModel
}

struct ShowModel: Codable {
    let image: ShowImage
    let name: String
}

struct ShowImage: Codable {
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "medium"
    }
}
