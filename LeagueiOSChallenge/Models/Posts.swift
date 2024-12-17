//
//  Posts.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

// MARK: Posts API data Model
struct Post: Codable, Identifiable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}
