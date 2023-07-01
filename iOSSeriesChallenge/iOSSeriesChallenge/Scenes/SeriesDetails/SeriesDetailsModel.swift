//
//  SeriesDetailsModel.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

struct SerieDetails: Codable {
    let name: String
    let schedule: SerieSchedule
    let image: ShowImage
    let genres: [String]
    let summary: String
}

struct SerieSchedule: Codable {
    let time: String
    let days: [String]
}

struct SerieEpisodes: Codable {
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: ShowImage
}

struct SerieSeason: Codable {
    let id: Int
    let number: Int
}

struct Episode: Codable {
    let name: String
    let number: Int
    let summary: String?
    let season: Int
    let image: ShowImage?
}
