//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 01.12.2022.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get set }
    func updateAvatar()
    func onLogout()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    lazy var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    } ()
    
    private var gradientAvatar: CAGradientLayer!
    private var gradientName: CAGradientLayer!
    private var gradientLogin: CAGradientLayer!
    private var gradientDescription: CAGradientLayer!
    private var animationGradient = AnimationGradientFactory.shared
    
    
    private var userPick: UIImageView = {
        let profileImage = UIImage(imageLiteralResourceName: "user_pick")
        let userPick = UIImageView(image: profileImage)
        userPick.clipsToBounds = true
        userPick.layer.cornerRadius = 35
        userPick.translatesAutoresizingMaskIntoConstraints = false
        return userPick
    }()
    
    private var userName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.asset(FontAsset.ysDisplayBold, size: 23)
        name.textColor = .ypWhite
        return name
    } ()
    
    private var userTag: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.font = UIFont.systemFont(ofSize: 13)
        tag.textColor = .ypGray
        return tag
    } ()
    
    private var userText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 13)
        text.textColor = .ypWhite
        return text
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(Self.didTapLogoutButton))
        button.accessibilityIdentifier = "logout button"
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfileContent()
        addConstraints()
        prepareAction()
        presenter.view = self
        presenter.viewDidLoad()
        updateProfileDetails(profile: profileService.profile)
    }
    
    private func addProfileContent() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(userPick)
        gradientAvatar = animationGradient.createGradient(width: 70, height: 70, cornerRadius: 35)
        userPick.layer.addSublayer(gradientAvatar)
        
        view.addSubview(userName)
        gradientName = animationGradient.createGradient(width: 223, height: 23, cornerRadius: 11.5)
        userName.layer.addSublayer(gradientName)
        
        view.addSubview(userTag)
        gradientLogin = animationGradient.createGradient(width: 89, height: 18, cornerRadius: 9)
        userTag.layer.addSublayer(gradientLogin)
        
        view.addSubview(userText)
        gradientDescription = animationGradient.createGradient(width: 67, height: 18, cornerRadius: 9)
        userText.layer.addSublayer(gradientDescription)
        
        view.addSubview(logoutButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            userPick.widthAnchor.constraint(equalToConstant: 70),
            userPick.heightAnchor.constraint(equalToConstant: 70),
            userPick.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userPick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userName.topAnchor.constraint(equalTo: userPick.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: userPick.leadingAnchor),
            userTag.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            userTag.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            userText.topAnchor.constraint(equalTo: userTag.bottomAnchor, constant: 8),
            userText.leadingAnchor.constraint(equalTo: userTag.leadingAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: userPick.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -18)
        ])
    }
    
    func onLogout() {
        OAuth2TokenStorage().clearToken()
        CookiesCleaner.clean()
        CacheCleaner.clean()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    @objc
    private func didTapLogoutButton(){
        let alert = presenter.showLogoutAlert()
        present(alert, animated: true)
    }
}

extension ProfileViewController {
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        userName.text = profile.name
        userTag.text = profile.login
        userText.text = profile.bio
        
        gradientName.removeFromSuperlayer()
        gradientLogin.removeFromSuperlayer()
        gradientDescription.removeFromSuperlayer()
    }
}

extension ProfileViewController {
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        userPick.kf.indicatorType = .activity
        userPick.kf.setImage(with:url,
                             placeholder: UIImage(named: "stub"),
                             options: [
                                .transition(.fade(1)),
                                .processor(processor),
                                .cacheOriginalImage])
        gradientAvatar.removeFromSuperlayer()
    }
}

extension ProfileViewController {
    private func prepareAction() {
        logoutButton.addTarget(
            self,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
    }
}









