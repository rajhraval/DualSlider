//
//  RatingItem+CoreDataProperties.swift
//  RatingApp
//
//  Created by Raj Raval on 09/11/20.
//
//

import Foundation
import CoreData


extension RatingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatingItem> {
        return NSFetchRequest<RatingItem>(entityName: "RatingItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var lowerValue: Int16
    @NSManaged public var upperValue: Int16
    @NSManaged public var date: Date?

}

extension RatingItem : Identifiable {

}

