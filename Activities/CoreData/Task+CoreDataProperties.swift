//
//  Task+CoreDataProperties.swift
//  Activities
//
//  Created by Chikinov Maxim on 23.03.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var date: Date?
    @NSManaged public var descripton: String?
    @NSManaged public var iconData: Data?
    @NSManaged public var state: Int16
    @NSManaged public var taskId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var groups: NSSet?

}

// MARK: Generated accessors for groups
extension Task {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

extension Task : Identifiable {

}
