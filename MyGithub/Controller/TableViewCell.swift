//
//  TableViewCell.swift
//  MyGithub
//
//  Created by imhs on 4/1/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    // MARK: - 리포지토리 명
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 리포지토리 설명
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - 리포지토리 언어
    var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    /* Interface Builder (스토리보드 또는 xib 파일)에서 로드될 때 호출되는 메서드이므로 코드로만 작성하는 경우 호출되지 않아 주석처리 가능
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    */

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - 초기화 메서드 오버라이드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellUI()
    }
    
    // MARK: - Cell 오토레이아웃 설정
    func cellUI() {
        //오토레이아웃 사용을 위한 설정
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Cell에 오브젝트 추가 
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(languageLabel)
        
        NSLayoutConstraint.activate([
            //nameLabel
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            //descriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            //languageLabel
            languageLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
