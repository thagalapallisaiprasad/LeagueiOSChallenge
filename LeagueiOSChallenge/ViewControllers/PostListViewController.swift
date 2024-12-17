//
//  PostListViewController.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import UIKit
import Combine

// MARK: PostListViewController
class PostListViewController: UIViewController {
  private var viewModel = UserViewModel()
  private var cancellables = Set<AnyCancellable>()
  private let tableView = UITableView()
  private var selectedUser: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
    viewModel.fetchUsers()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    self.navigationController?.navigationBar.topItem?.hidesBackButton = true
  }
  
  private func setupUI() {
    title = "Users"
    view.backgroundColor = .white
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    
    // Add navigation bar buttons for login user or guest
    if AppDelegate.sharedInstance.isFromGuestLogin ?? true {
      let exitButton = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(handleExit))
      navigationItem.rightBarButtonItem = exitButton
    } else {
      let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
      navigationItem.rightBarButtonItem = logoutButton
    }
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  // response data binding to the view
  private func bindViewModel() {
    viewModel.$posts
      .sink { [weak self] posts in
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
      .store(in: &cancellables)
    
    viewModel.$errorMessage
      .compactMap { $0 }
      .sink { [weak self] error in
        self?.showError(message: error)
      }
      .store(in: &cancellables)
  }
  
  private func showError(message: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }
  }
  
  // Modal presentation for individual user
  private func presentUserInformationViewController(for user: User) {
    let userInfoVC = UserInformationViewController()
    userInfoVC.configure(with: user)
    userInfoVC.modalPresentationStyle = .formSheet
    present(userInfoVC, animated: true)
  }
  
  // Handle navigation for login user or guest user
  private func navigateToLogin() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func handleExit() {
    let alert = UIAlertController(title: "Thank you for trialing this app", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.navigateToLogin()
    }))
    present(alert, animated: true)
  }
  
  @objc private func handleLogout() {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: TableView delegates
extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
    
    let post = viewModel.posts[indexPath.row]
    let user = viewModel.users.first { $0.id == post.userId }!
    
    cell.configure(with: user, post: post)
    
    cell.onAvatarTap = { [weak self] in
      guard let user = cell.cellUser else { return }
      self?.presentUserInformationViewController(for: user)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedUser = viewModel.users.first { $0.id == viewModel.posts[indexPath.row].userId }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

