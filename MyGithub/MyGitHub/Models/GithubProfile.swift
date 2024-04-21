//
//  GithubProfile.swift
//  MyGitHub
//
//  Created by imhs on 4/21/24.
//

import Foundation

// GitHub 프로필 정보를 저장할 구조체
struct GithubProfile: Decodable {
    var login: String       //깃허브 ID
    var name: String           //이름
    var bio: String         //bio
    var avatarUrl: URL      //프로필 사진
    var followers: Int      //팔로워
    var following: Int      //팔로잉
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case bio
        case followers
        case following
        case avatarUrl = "avatar_url"
    }
}
