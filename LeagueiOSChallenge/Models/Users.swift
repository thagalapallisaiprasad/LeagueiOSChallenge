//
//  Users.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import Foundation

// MARK: User API data Model
struct User: Codable {
  let id: Int
  let avatar: String
  let name, username, email: String
  let address: Address
  let phone, website: String
  let company: Company
}

struct Address: Codable {
  let street, suite, city, zipcode: String
  let geo: Geo
}

struct Geo: Codable {
  let lat, lng: String
}

struct Company: Codable {
  let name, catchPhrase, bs: String
}
