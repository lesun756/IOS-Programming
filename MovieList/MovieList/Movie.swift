//
//  Movie.swift
//  MovieList
//
//  Created by 杨丽婧 on 2020/2/27.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class Movie: NSObject {
}

struct MovieInfo: Decodable {
    let id: Int?
    let posterPath: String?
    let title: String?
    let backdropPath: String?
    let vote: Double?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", title, backdropPath = "backdrop_path", vote = "vote_average", overview
    }
}

struct MovieDetails: Decodable {
    let id: Int?
    let posterPath: String?
    let title: String?
    let backdropPath: String?
    let vote: Double?
    let voteNumber: Int?
    let overview: String?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", title, backdropPath = "backdrop_path", vote = "vote_average", overview, voteNumber = "vote_count", releaseDate = "release_date"
    }
}

struct backInfo: Decodable {
    let filePath: String?
    
    private enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

struct MovieImages: Decodable {
    let id: Int?
    var backdrops: [backInfo]
    var posters: [backInfo]

    private enum CodingKeys: String, CodingKey {
        case id, backdrops, posters
    }
}

struct MovieResults: Decodable {
    let page: Int?
    let numResults: Int?
    let numPages: Int?
    var movies: [MovieInfo]

    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", movies = "results"
    }
}
