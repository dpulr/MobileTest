//
//  UserModel.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import Foundation

struct UserData: Decodable {
    
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

struct Address: Decodable {
    
    let street, suite, city, zipcode: String
    let geo: Geo
}

struct Geo: Decodable {
    
    let lat, lng: String
}

struct Company: Decodable {
    
    let name, catchPhrase, bs: String
}

struct ChoosenUser {
    
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}
