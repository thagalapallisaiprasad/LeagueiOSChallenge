//
//  PostTableViewCell.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import UIKit

 //MARK: Custom UserDetails tableview cell
class PostTableViewCell: UITableViewCell {
  let avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 25
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .black
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.numberOfLines = 0
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .gray
    label.numberOfLines = 0
    return label
  }()
  
  var cellUser: User?
  
  //Closure to handle modal presentation with Avatar or username
  var onAvatarTap: (() -> Void)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    
    contentView.addSubview(avatarImageView)
    contentView.addSubview(usernameLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    
    // Tap gesture for Avatar and Username
    let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAvatarTap))
    let usernameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAvatarTap))
    
    avatarImageView.addGestureRecognizer(avatarTapGesture)
    usernameLabel.addGestureRecognizer(usernameTapGesture)
    
    avatarImageView.isUserInteractionEnabled = true
    usernameLabel.isUserInteractionEnabled = true
    
    // Adding constrains fod the objects
    NSLayoutConstraint.activate([
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 50),
      avatarImageView.heightAnchor.constraint(equalToConstant: 50),
      
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
      usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      
      titleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
      
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func handleAvatarTap() {
    onAvatarTap?()
  }
  
  func configure(with user: User, post: Post) {
    self.cellUser = user
    
    ImageDownloader.downloadImage(from: user.avatar, completion: { [weak self] image in
      self?.avatarImageView.image = image
    })
    
    usernameLabel.text = user.username
    titleLabel.text = post.title
    descriptionLabel.text = post.body
  }
}
