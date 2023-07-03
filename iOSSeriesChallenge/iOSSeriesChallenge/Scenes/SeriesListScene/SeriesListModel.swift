//
//  MovieListModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

struct HomeSeriesListModel: Codable, Equatable {
    let _embedded: EmbeddedShow
}

struct EmbeddedShow: Codable, Equatable {
    let show: ShowModel
}

struct ShowModel: Codable, Equatable {
    let id: Int
    let name: String
    let image: ShowImage?
}

struct ShowImage: Codable, Equatable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "medium"
    }
}
