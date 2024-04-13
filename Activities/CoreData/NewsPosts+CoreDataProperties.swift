//
//  NewsPosts+CoreDataProperties.swift
//  Activities
//
//  Created by Chikinov Maxim on 12.04.2024.
//
//

import Foundation
import CoreData


extension NewsPosts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsPosts> {
        return NSFetchRequest<NewsPosts>(entityName: "NewsPosts")
    }

    @NSManaged public var date: String?
    @NSManaged public var image: String?
    @NSManaged public var postID: Int32
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension NewsPosts : Identifiable {

}
