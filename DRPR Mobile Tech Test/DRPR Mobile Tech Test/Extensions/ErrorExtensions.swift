//
//  ErrorExtensions.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import Foundation

// MARK: - Enum
enum ErrorCases: Error {
    
    case usedURL
    case unknown
    case apiCalling
    case decoding
    case userNotFound
}


// MARK: - Localized Errors
extension ErrorCases: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .usedURL:
            return "error.usedURL".localized
        case .apiCalling:
            return "error.apiCalling".localized
        case .decoding:
            return "error.decoding".localized
        case .userNotFound:
            return "error.userNotFound".localized
        case .unknown:
            return "error.unknown".localized
        }
    }
}
