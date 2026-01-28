//
//  SeriesDetailsModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

// MARK: - Series Details Models

/// Detailed information about a TV series
struct SerieDetails: Codable {
    let name: String
    let schedule: SerieSchedule
    let image: ShowImage
    let genres: [String]
    let summary: String?
}

/// Schedule information for when a show airs
struct SerieSchedule: Codable {
    let time: String
    let days: [String]
}

/// Legacy model for episode data (consider consolidating with Episode)
struct SerieEpisodes: Codable {
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: ShowImage
}

// MARK: - Season & Episode Models

/// Information about a TV season
struct SerieSeason: Codable {
    let id: Int
    let number: Int
}

/// Information about a TV episode
struct Episode: Codable {
    let name: String
    let number: Int?
    var summary: String?
    let season: Int
    let image: ShowImage?
}
