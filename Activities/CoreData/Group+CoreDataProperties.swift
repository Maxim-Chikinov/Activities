//
//  Group+CoreDataProperties.swift
//  Activities
//
//  Created by Chikinov Maxim on 23.03.2024.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var icon: Data?
    @NSManaged public var subtitle: String?
    @NSManaged public var name: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Group {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Group : Identifiable {

}
