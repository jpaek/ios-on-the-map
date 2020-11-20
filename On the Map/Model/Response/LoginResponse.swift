//
//  LoginResponse.swift
//  On the Map
//
//  Created by Jae Paek on 4/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: UdacityAccount?
    let session: UdacitySession?
    let status: Int?
    let error: String?
    
    init(from decoder: Decoder) throws {
        do {
            let map = try decoder.container(keyedBy: CodingKeys.self)
            self.account = try? map.decode(UdacityAccount.self, forKey: .account)
            self.session = try? map.decode(UdacitySession.self, forKey: .session)
            self.status = try? map.decode(Int.self, forKey: .status)
            self.error = try? map.decode(String.self, forKey: .error)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
        case status
        case error
    }
}

struct UdacityAccount: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}

struct UdacitySession: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}
