//
//  ShowFavoritesItem+CoreDataProperties.swift
//  
//
//  Created by Gabriel Monteiro Camargo da Silva on 04/03/24.
//
//

import Foundation
import CoreData

extension ShowFavoritesItem {

    @nonobjc class func fetchRequest() -> NSFetchRequest<ShowFavoritesItem> {
        return NSFetchRequest<ShowFavoritesItem>(entityName: "ShowFavoritesItem")
    }

    @NSManaged var genres: [String]?
    @NSManaged var id: Int32
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var scheduleDays: [String]?
    @NSManaged var scheduleTime: String?
    @NSManaged var summary: String?
    
    func toShowModel() -> ShowModel {
        let id = Int(id)
        let name = name ?? ""
        let genres = genres ?? []
        let time = scheduleTime ?? ""
        let days = scheduleDays ?? []
        let showSchedule = ShowSchedule(time: time, days: days)
        let image = image != nil ? ShowImage(medium: image ?? "") : nil
        let summary = summary ?? ""
        return ShowModel(id: id, name: name, genres: genres, schedule: showSchedule, image: image, summary: summary)
    }
}
