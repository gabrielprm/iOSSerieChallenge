//
//  SeriesListModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

// MARK: - API Response Models

/// Represents the top-level response from the full schedule API
struct HomeSeriesListModel: Codable, Equatable {
    let _embedded: EmbeddedShow
}

/// Wrapper for show data from the search API
struct EmbeddedShow: Codable, Equatable {
    let show: ShowModel
}

/// Basic show information
struct ShowModel: Codable, Equatable {
    let id: Int
    let name: String
    let image: ShowImage?
}

/// Image URLs for show artwork
struct ShowImage: Codable, Equatable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "medium"
    }
}
