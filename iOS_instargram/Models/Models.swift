//
//  Models.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/09/23.
//

import Foundation

struct User {
    let username: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let bio: String
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following : Int
    let post: Int
}

enum Gender {
    case male, female, other
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
}

public struct PostLike {
    let userName: String
    let postIdentifier: String
    
}

public struct PostComment {
    let identifier: String
    let userName: String
    let text: String
    let createdDate: Date
    let likeCount: [commentLike]
}

public struct commentLike {
    let userName: String
    let commentIdentifier: String
}

public enum UserPostType {
    case photo, video
}
