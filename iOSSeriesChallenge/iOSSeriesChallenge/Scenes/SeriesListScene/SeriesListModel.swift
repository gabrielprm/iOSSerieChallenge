//
//  MovieListModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

struct HomeSeriesListModel: Codable {
    let _embedded: EmbeddedShow
}

struct EmbeddedShow: Codable {
    let show: ShowModel
}

struct ShowModel: Codable {
    let id: Int
    let name: String
    let image: ShowImage?
}

struct ShowImage: Codable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "medium"
    }
}
