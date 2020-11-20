//
//  LoginRequest.swift
//  On the Map
//
//  Created by Jae Paek on 4/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import Foundation

import Foundation

struct LoginRequest: Codable {
    
    let udacity: UdacityLoginRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}

struct UdacityLoginRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
