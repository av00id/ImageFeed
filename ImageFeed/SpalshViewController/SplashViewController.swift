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
    
    private let showAuthScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let errorAlertController = ErrorAlertViewController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuth()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    private func checkAuth() {
        if let token = oauth2TokenStorage.token {
            switchToTabBarController()
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthScreenSegueIdentifier, sender: nil)
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
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.switchToTabBarController()
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showError()
            }
        }
    }
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let username):
                ProfileImageService.shared.fetchProfileImageURL(username: username,
                                                                token: token) { _ in }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
            case .failure:
                self.showError()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension SplashViewController {
    private func showError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorAlertController
                .showAlert(
                    over: self,
                    title: "Ошибка!",
                    message: "Что-то пошло не так..",
                    actionTitle: "Ok") {
                        self.checkAuth()
                    }
        }
    }
}
