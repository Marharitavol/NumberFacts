//
//  OptionsTypes.swift
//  aliTest
//
//  Created by Rita on 04.12.2023.
//

import Foundation

enum Types: String {
    case trivia
    case math
    case date
    case year
    
    var title: String {
        switch self {
        case .trivia:
            return "Trivia"
        case .math:
            return "Math"
        case .date:
            return "Date"
        case .year:
            return "Year"
        }
    }
}
