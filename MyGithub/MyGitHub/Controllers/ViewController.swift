//
//  ViewController.swift
//  MyGitHub
//
//  Created by imhs on 4/21/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let userName = "limlogging"
    
    var profile: GithubProfile?
    var repositories: [GithubRepositories] = []
    var page: Int = 1
    var isLoadingLast = false
    
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
    var profileBio: UILabel = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileUI()                 //깃허브프로필 오토레이아웃 설정
        repositoriesUI()            //테이블 뷰 오토레이아웃 설정
        
        configureData()             //깃허브 정보 가져오기
        configureTableView()        //테이블 뷰 셋팅
        
    }
    
    // MARK: - 깃허브 프로필 오토레이아웃 설정
    func profileUI() {
        view.addSubview(profileView)
        view.addSubview(profileImageView)
        view.addSubview(profileName)
        view.addSubview(profileLogin)
        view.addSubview(profileBio)
        view.addSubview(profileFollowers)
        view.addSubview(profileFollowing)
        
        //profileView
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileLogin.translatesAutoresizingMaskIntoConstraints = false
        profileBio.translatesAutoresizingMaskIntoConstraints = false
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
            
            //profileBio
            profileBio.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileBio.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
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
    
    // MARK: - 데이터 설정
    func configureData() {
        page = 1
        isLoadingLast = false
        
        // MARK: - 깃허브 프로필 가져오기, 강한 순환 참조를 피하기 위해서 [weak self] 사용
        networkManager.fetchUserProfile(userName: userName) { [weak self] result in
            switch result {
            case .success(let githubProfile):
                self?.profile = githubProfile
                
                DispatchQueue.main.async {
                    self?.profileName.text = githubProfile.name                             //이름
                    self?.profileLogin.text = githubProfile.login                           //ID
                    self?.profileBio.text = githubProfile.bio                               //BIO
                    self?.profileFollowers.text = "followers: \(githubProfile.followers)"   //follwers
                    self?.profileFollowing.text = "following: \(githubProfile.following)"   //follwing
                    self?.profileImageView.kf.setImage(with: githubProfile.avatarUrl)       //프로필사진
                    
                    self?.view.setNeedsDisplay()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // MARK: - 깃허브 리포지토리 가져오기, 강한 순환 참조를 피하기 위해서 [weak self] 사용
        networkManager.fetchUserRepositories(userName: userName, page: self.page) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                DispatchQueue.main.async {
                    self?.repositoriesTableView.refreshControl?.endRefreshing() //새로고침 끝내기
                    self?.repositoriesTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 테이블뷰 설정
    func configureTableView() {
        repositoriesTableView.dataSource = self
        repositoriesTableView.delegate = self
        repositoriesTableView.rowHeight = 80
        
        // 셀 클래스 등록
        repositoriesTableView.register(TableViewCell.self, forCellReuseIdentifier: "CellId")
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        repositoriesTableView.refreshControl = refreshControl
    }
    
    // MARK: - pull to refresh 메서드
    @objc func refreshData() {
        configureData()
    }
    
    // MARK: - 페이징 처리
    func loadMore() {
        if isLoadingLast == true {
            print("마지막 페이지")
            return
        }
        page += 1
        networkManager.fetchUserRepositories(userName: userName, page: page) { [weak self] result in
            // self에 대한 약한 참조를 만들어 strong reference cycle을 방지합니다.
            guard let self = self else { return } // self가 nil이라면 함수를 종료합니다.
            
            switch result {
            case .success(let repositories):
                
                //api 호출결과가 비어있으면 마지막으로 인식
                if repositories.isEmpty == true {
                    self.isLoadingLast = true   //마지막 저장소 로딩
                    return
                }
                
                self.repositories = self.repositories + repositories    //기존 배열에 새로 불러온 데이터 추가하기
                //UI 다시 그리기는 메인큐
                DispatchQueue.main.async {
                    self.repositoriesTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("repositories.count: \(repositories.count)")
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let repositories = repositories[indexPath.row]
        cell.bind(repositories)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    //특정 셀이 화면에 나타나기 전에 실행 (셀이 화면에 나타나기 전에 수행되어야 하는 작업이 필요할때)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //셀의 마지막에 도착했을때 데이터 다시 로드
        if indexPath.row == repositories.count - 1 {
            loadMore()
        }
    }
}
