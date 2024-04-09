//
//  GithubProfile.swift
//  MyGithub
//
//  Created by imhs on 4/1/24.
//

import Foundation

// GitHub 프로필 정보를 저장할 구조체
struct GithubProfile {
    //var myImage: UIImage?
    var myImage: URL        //프로필 사진
    var name: String        //이름
    var login: String       //깃허브 ID
    var followers: Int      //팔로워
    var following: Int      //팔로잉
    var repoCnt: Int        //리포지토리 개수 
}
