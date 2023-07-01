//
//  MovieListErrors.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

enum ServiceSeriesListErrors: LocalizedError {
    case urlNil
    case dataNil
    case parseFailure
    case imageDownload
    case httpResponse
    
    var errorDescription: String {
        switch self {
        case .urlNil:
            return "URL not found!"
        case .dataNil:
            return "Could not download data"
        case .parseFailure:
            return "Invalid Data"
        case .imageDownload:
            return "Could not download image"
        case .httpResponse:
            return "Invalid Response"
        }
    }
}
