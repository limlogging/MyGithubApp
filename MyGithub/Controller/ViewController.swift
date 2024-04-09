//
//  ViewController.swift
//  MyGithub
//
//  Created by imhs on 3/31/24.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    let profileUrl = "https://api.github.com/users/limlogging"
    let repositoriesUrl = "https://api.github.com/users/limlogging/repos"
    var repoCnt: Int = 0
    
    var repoArr: [GithubRepositories] = []
    
    // MARK: - 깃허브 프로필을 보여줄 View
    var profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // MARK: - 프로필 이미지 뷰
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return imageView
    }()
    
    // MARK: - 프로필 이름
    var profileName: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 아이디
    var profileLogin: UILabel = {
        let label = UILabel()
        label.text = "Login"
        return label
    }()
    
    // MARK: - 인사
    var profileIntroduce: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요! 반갑습니다!"
        return label
    }()
    
    // MARK: - 팔로워
    var profileFollowers: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        return label
    }()
    
    // MARK: - 팔로잉
    var profileFollowing: UILabel = {
        let label = UILabel()
        label.text = "Following"
        return label
    }()
    
    // MARK: - repositoriesView 추가
    var repositoriesView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // MARK: - 테이블 뷰 추가
    var repositoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return tableView
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesTableView.delegate = self
        repositoriesTableView.dataSource = self
        repositoriesTableView.rowHeight = 80
        
        profileUI()                 //깃허브프로필 오토레이아웃 설정
        repositoriesUI()            //테이블 뷰 오토레이아웃 설정
        getGithubProfile()          //깃허브에서 프로필 정보 가져오기
        getGithubRepositories()     //깃허브에서 리포지토리 정보 가져오기
        
        // 셀 클래스 등록
        repositoriesTableView.register(TableViewCell.self, forCellReuseIdentifier: "CellId")
        
        //Pull to refresh 추가
        tableViewRefresh()
    }
    
    // MARK: - Pull to refresh 컨트롤 추가
    func tableViewRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        repositoriesTableView.refreshControl = refreshControl
    }
    
    // MARK: - pull to refresh 메서드
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 테이블 뷰 리로드
            self.repositoriesTableView.reloadData()
            // UIRefreshControl 종료
            self.repositoriesTableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - 깃허브에서 리포지토리 정보 가져오기
    func getGithubRepositories() {
        AF.request(repositoriesUrl).responseJSON { response in
            switch response.result {
            case.success(let value):
                if let repositories = value as? [[String: Any]] {
                    for repo in repositories {
                        if let name = repo["name"] as? String,
                            let htmlUrl = repo["html_url"] as? String {
                                //description, language는 없거나 Null 값이 있어서 닐 코얼레싱 추가
                                let description = repo["description"] as? String ?? ""
                                let language = repo["language"] as? String ?? ""
                                
                                //배열에 저장
                                self.repoArr.append(GithubRepositories(name: name, htmlUrl: htmlUrl, description: description, language: language))
                        }
                    }
                }
            case .failure(let error):
                print("에러: \(error)")
            }
        }
    }
    
    // MARK: - 깃허브에서 프로필 정보 가져오기
    func getGithubProfile() {
        AF.request(profileUrl).responseJSON { response in
            switch response.result {
            case.success(let value):
                if let json = value as? [String: Any],
                   let name = json["name"] as? String,
                   let login = json["login"] as? String,
                   let followers = json["followers"] as? Int,
                   let following = json["following"] as? Int,
                   let repoCnt = json["public_repos"] as? Int,
                   let avatarURLString = json["avatar_url"] as? String,
                   let avatarURL = URL(string: avatarURLString) {
                    
                    let profile = GithubProfile(myImage: avatarURL, name: name, login: login, followers: followers, following: following, repoCnt: repoCnt)
                    
                    self.showProfileInfo(profile)
//                    //이미지 다운로드
//                    AF.download(avatarURL).responseData { response in
//                        if let data = response.value {
//                            //다운로드할 이미지를 UIImageView에 표시
//                            let image = UIImage(data: data)
//                            
//                            //구조체 저장
//                            let profile = GithubProfile(myImage: image, name: name, login: login, followers: followers, following: following)
//                            
//                            // 저장된 정보를 화면에 출력하는 함수 호출
//                            self.showProfileInfo(profile)
//                            //self.profileImageView.image = image
//                        }
//                    }
                    
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    // MARK: - 깃허브 프로필 오토레이아웃 설정
    func profileUI() {
        view.addSubview(profileView)
        view.addSubview(profileImageView)
        view.addSubview(profileName)
        view.addSubview(profileLogin)
        view.addSubview(profileIntroduce)
        view.addSubview(profileFollowers)
        view.addSubview(profileFollowing)
                
        //profileView
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileLogin.translatesAutoresizingMaskIntoConstraints = false
        profileIntroduce.translatesAutoresizingMaskIntoConstraints = false
        profileFollowers.translatesAutoresizingMaskIntoConstraints = false
        profileFollowing.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //profileView
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            profileView.heightAnchor.constraint(equalToConstant: 200),
            
            //profileImageView
            profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            //profileName
            profileName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0),
            
            //profileLogin
            profileLogin.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileLogin.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 2),
            
            //profileIntroduce
            profileIntroduce.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileIntroduce.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            //profileFollowers
            profileFollowers.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileFollowers.bottomAnchor.constraint(equalTo: profileFollowing.topAnchor, constant: 2),
            
            //profileFollowing
            profileFollowing.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileFollowing.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
    }
    
    // MARK: - repositories View
    func repositoriesUI() {
        //repositoriesView
        view.addSubview(repositoriesView)
        view.addSubview(repositoriesTableView)
        
        //repositoriesView
        repositoriesView.translatesAutoresizingMaskIntoConstraints = false
        repositoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //repositoriesView
            repositoriesView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 10),
            repositoriesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            repositoriesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            repositoriesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            //repositoriesTableView
            repositoriesTableView.topAnchor.constraint(equalTo: repositoriesView.topAnchor, constant: 10),
            repositoriesTableView.leadingAnchor.constraint(equalTo: repositoriesView.leadingAnchor, constant: 10),
            repositoriesTableView.trailingAnchor.constraint(equalTo: repositoriesView.trailingAnchor, constant: -10),
            repositoriesTableView.bottomAnchor.constraint(equalTo: repositoriesView.bottomAnchor, constant: -10)
        ])
    }
    
    // 구조체에서 데이터를 가져와 label 및 imageView에 보여주는 함수
    func showProfileInfo(_ profile: GithubProfile) {
        // 프로필 이미지 출력
//        if let profileImage = profile.myImage {
//            profileImageView.image = profileImage
//        }
        //SDWebImage를 사용하여 프로필 이미지 다운로드 및 출력
        profileImageView.sd_setImage(with: profile.myImage, placeholderImage: nil, options: [], completed: nil)
        
        profileName.text = profile.name     // 이름 출력
        profileLogin.text = profile.login   // 로그인 출력
        profileFollowers.text = "Followers: \(String(profile.followers))"   //followers
        profileFollowing.text = "Following: \(String(profile.following))"   //following
        
        self.repoCnt = profile.repoCnt
        repositoriesTableView.reloadData()  //최초 실행하면 numberOfRowsInSection를 먼저 실행하고 깃허브 데이터를 받아와서 row 수가 0임, row수를 깃허브 repo수 만큼 보이도록 새로고침 추가 
    }
}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! TableViewCell
        
        //깃허브에서 데이터를 불러오기도 전에 cellForRowAt이 실행되어 추가
        if repoArr.count != 0 {
            cell.nameLabel.text = repoArr[indexPath.row].name
            cell.descriptionLabel.text = repoArr[indexPath.row].description
            cell.languageLabel.text = repoArr[indexPath.row].language
        } else {
            repositoriesTableView.reloadData()
        }
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(repoArr[indexPath.row].htmlUrl)
    }
}

