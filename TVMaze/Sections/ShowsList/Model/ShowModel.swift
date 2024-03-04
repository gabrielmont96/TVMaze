//
//  ShowsListModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

struct ShowModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let genres: [String]
    let schedule: ShowSchedule
    let image: ShowImage?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case id, name, genres, schedule, image, summary
    }
}

struct ShowImage: Decodable {
    let medium: String
}

struct ShowSchedule: Decodable {
    let time: String
    let days: [String]
}

struct ShowSearchModel: Decodable {
    let show: ShowModel
}
