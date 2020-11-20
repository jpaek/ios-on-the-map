//
//  OnTheMapResponse.swift
//  On the Map
//
//  Created by Jae Paek on 4/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import Foundation

struct OnTheMapResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
