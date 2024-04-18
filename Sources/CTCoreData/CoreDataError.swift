//
//  CoreDataError.swift
//
//
//  Created by Cem Telliagaoglu on 17.04.2024.
//

import Foundation

public enum CoreDataError: Error {
    
    case create, fetch, read, update, delete, save, unknown, storage

    public var customMessage: String {
        switch self {
        case .create:
            return "Failed to create entity"
        case .fetch:
            return "Failed to fetch entity"
        case .read:
            return "Couldn't read entity"
        case .update:
            return "Failed to update context"
        case .delete:
            return "Failed to delete entity"
        case .save:
            return "An error occured while saving context"
        case .storage:
            return "An error occured while setting up storage."
        default:
            return "Unknown core data error"
        }
    }
}
