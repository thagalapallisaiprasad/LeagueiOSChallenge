//
//  UserInformationViewController.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import UIKit

// MARK: UserInformationViewController
class UserInformationViewController: UIViewController {
  
  private let avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 50
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = .black
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .gray
    return label
  }()
  
  private let warningIcon: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
    imageView.tintColor = .red
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isHidden = true
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Setup UI
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(avatarImageView)
    view.addSubview(usernameLabel)
    view.addSubview(emailLabel)
    view.addSubview(warningIcon)
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 100),
      avatarImageView.heightAnchor.constraint(equalToConstant: 100),
      
      usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
      usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
      emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      warningIcon.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
      warningIcon.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 5)
    ])
  }
  
  // User details
  func configure(with user: User) {
    ImageDownloader.downloadImage(from: user.avatar, completion: { image in
      self.avatarImageView.image = image
    })
    usernameLabel.text = user.username
    emailLabel.text = user.email
    
    if !isValidEmail(user.email) {
      warningIcon.isHidden = false
    }
  }
  
  // Validate user email
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|net|biz)"
    let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
}
