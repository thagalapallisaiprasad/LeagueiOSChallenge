//
//  ViewController.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import UIKit
import Combine

// MARK: LoginViewController
class LoginViewController: UIViewController {
  private var viewModel = LoginViewModel()
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: UI Components
  private let usernameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Username"
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let guestButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Continue as Guest", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindActions()
    bindViewModel()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    usernameTextField.text = ""
    passwordTextField.text = ""
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(usernameTextField)
    view.addSubview(passwordTextField)
    view.addSubview(loginButton)
    view.addSubview(guestButton)
    
    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
      passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
      passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
      
      loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
      loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      guestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
      guestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  // Add click actions for login and guest user
  private func bindActions() {
    loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    guestButton.addTarget(self, action: #selector(handleGuestLogin), for: .touchUpInside)
  }
  
  // Bind the data and navigate the ViewController
  private func bindViewModel() {
    viewModel.$userToken
      .sink { [weak self] token in
        if let token = token, !token.isEmpty {
          DispatchQueue.main.async {
            self?.navigateToPostList()
          }
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
  
  private func navigateToPostList() {
    let postListVC = PostListViewController()
    self.navigationController?.pushViewController(postListVC, animated: true)
  }
  
  @objc private func handleLogin() {
    AppDelegate.sharedInstance.isFromGuestLogin = false
    viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
  }
  
  @objc private func handleGuestLogin() {
    AppDelegate.sharedInstance.isFromGuestLogin = true
    viewModel.continueAsGuest()
  }
  
  private func showError(message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
