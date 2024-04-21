//
//  NetworkManager.swift
//  MyGitHub
//
//  Created by imhs on 4/21/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    let url = "https://api.github.com/users/"
    
    // MARK: - URLSession으로 깃허브 프로필 가져오기
    func fetchUserProfile(userName: String, completionHandler: @escaping (Result<GithubProfile, Error>) -> Void) {
        //1. url 구조체 생성
        guard let url = URL(string: "\(self.url)\(userName)") else {
            completionHandler(.failure(NSError(domain: "url 변환에 실패했어요.", code: 401)))
            return
        }
        
        //2. request 설정
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //3. 작업 만들기
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completionHandler(.failure(error))
                return
            }
            guard let data else {
                completionHandler(.failure(NSError(domain: "Data가 없습니다.", code: 402)))
                return
            }
            do {
                let profile = try JSONDecoder().decode(GithubProfile.self, from: data)
                //콜백함수로 데이터 전달
                completionHandler(.success(profile))
            } catch {
                completionHandler(.failure(error))
            }
        }
        //4. 작업시작
        task.resume()
    }
    
    // MARK: - 알라모파이어로 리포지토리 정보 가져오기
    func fetchUserRepositories(userName: String, page: Int, completionHandler: @escaping (Result<[GithubRepositories], Error>) -> Void) {
        let url = "\(self.url)\(userName)/repos?page=\(page)"
        
        AF.request(url).responseDecodable(of: [GithubRepositories].self) { response in
            switch response.result {
            case .success(let repositories):
                completionHandler(.success(repositories))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
