//
//  TaskState.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import Foundation

enum TaskState: Int, CaseIterable {
    case all
    case todo
    case inProgress
    case complete
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .todo:
            return "To-do"
        case .inProgress:
            return "In Progress"
        case .complete:
            return "Complete"
        }
    }
}
