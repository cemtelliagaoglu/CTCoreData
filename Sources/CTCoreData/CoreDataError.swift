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

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .create:
            return NSLocalizedString("error_create", bundle: .module, comment: "Create Error")
        case .fetch:
            return NSLocalizedString("error_fetch", bundle: .module, comment: "Fetch Error")
        case .read:
            return NSLocalizedString("error_read", bundle: .module, comment: "Read Error")
        case .update:
            return NSLocalizedString("error_update", bundle: .module, comment: "Update Error")
        case .delete:
            return NSLocalizedString("error_delete", bundle: .module, comment: "Delete Error")
        case .save:
            return NSLocalizedString("error_save", bundle: .module, comment: "Save Error")
        case .unknown:
            return NSLocalizedString("error_unknown", bundle: .module, comment: "Unknown Error")
        case .storage:
            return NSLocalizedString("error_storage", bundle: .module, comment: "Storage Error")
        }
    }
}
