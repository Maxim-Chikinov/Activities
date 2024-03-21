//
//  TaskState.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import Foundation

enum TaskState: Int16, CaseIterable {
    case todo
    case inProgress
    case complete
    case all
    
    var title: String {
        switch self {
        case .todo:
            return "To-do"
        case .inProgress:
            return "In Progress"
        case .complete:
            return "Complete"
        case .all:
            return "All"
        }
    }
}
