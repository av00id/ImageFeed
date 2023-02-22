//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 25.12.2022.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var isAuthorized: Bool = false
    private var maxRetryCount = 5
    
    private let showAuthScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let errorAlertController = ErrorAlertViewController()
    
    private var authLogo: UIImageView = {
        let image = UIImage(imageLiteralResourceName: "auth_screen_logo")
        let logoImage = UIImageView(image: image)
        logoImage.tintColor = .ypWhite
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAuthLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuth()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    private func checkAuth() {
        guard isAuthorized == false else {
            return
        }
        if oauth2TokenStorage.token != nil {
            fetchProfile()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as? AuthViewController else {
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthScreenSegueIdentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        isAuthorized = true
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.oauth2TokenStorage.token = token
                    self.fetchProfile()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showError()
                }
            }
        }
    }
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile() { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let self = self else { return }
                switch result {
                case .success(let username):
                    ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showError()
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension SplashViewController {
    private func showError() {
        let isRetryLimit = self.maxRetryCount >= 5
        errorAlertController
            .showAlert(
                over: self,
                title: "Что-то пошло не так(",
                message: isRetryLimit ? "Все сломалось" : "Попробовать еще раз?",
                actionTitle: isRetryLimit ? "Ок" : "Да") {
                    if !isRetryLimit {
                        self.checkAuth()
                    }
                }
    }
}

extension SplashViewController {
    private func showAuthLogo() {
        view.backgroundColor = .ypBlack
        view.addSubview(authLogo)
        NSLayoutConstraint.activate([
            authLogo.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            authLogo.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            authLogo.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.2),
            authLogo.heightAnchor.constraint(
                equalTo: authLogo.widthAnchor)
        ])}
}
