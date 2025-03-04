//
//  Reviews.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

struct Reviews: Codable {
    let id: Int?
    let page: Int?
    let results: [Review]?
    let totalPages: Int?
    let totalResults: Int?
}

struct Review: Codable, Identifiable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let createdAt: String?
    let id: String?
    let updatedAt: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

struct AuthorDetails: Codable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
