//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 15.02.2023.
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func showLogoutAlert() -> UIAlertController
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    func showLogoutAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let agreeAction = UIAlertAction(
            title: "Да", style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.onLogout()
            }
        }
        let dismissAction = UIAlertAction(
            title: "Нет",
            style: .default)
        
        alert.addAction(agreeAction)
        alert.addAction(dismissAction)
        
        return alert 
    }
}



