//
//  GithubRepositories.swift
//  MyGitHub
//
//  Created by imhs on 4/21/24.
//

import Foundation

// 리포지토리 정보를 저장할 구조체
struct GithubRepositories: Decodable {
    var name: String             //리포지토리 이름
    var language: String?        //언어
}
