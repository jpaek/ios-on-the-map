//
//  UserResponse.swift
//  On the Map
//
//  Created by Jae Paek on 11/20/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import Foundation

struct UserResponse<Element: Decodable>: Decodable {
    let user: [String: Element]
    
    
}
