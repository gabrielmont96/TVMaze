//
//  SeasonEpisodesModel.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 03/03/24.
//

import Foundation

struct SeasonEpisodesModel: Decodable {
    let name: String
    let number, season: Int?
    let summary: String?
    let image: ShowImage?
    var isExpanded: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, number, season, summary, image, isExpanded
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        number = try? values.decode(Int.self, forKey: .number)
        season = try? values.decode(Int.self, forKey: .season)
        image = try? values.decode(ShowImage.self, forKey: .image)
        summary = try? values.decode(String.self, forKey: .summary)
        isExpanded = false
    }
}
