//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 01.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var userPick: UIImageView = {
        let profileImage = UIImage(imageLiteralResourceName: "user_pick")
        let userPick = UIImageView(image: profileImage)
        userPick.translatesAutoresizingMaskIntoConstraints = false
        return userPick
    }()
    
    private var userName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Екатерина Новикова"
        name.font = UIFont.boldSystemFont(ofSize: 23)
        //name.font = UIFont(name: "YSDisplay-Bold", size: 23)
        //почему-то не удается использовать кастомный шрифт,через сториборд выставляется, но тут не срабатывает
        name.textColor = .ypWhite
        return name
    } ()
    
    private var userTag: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.text = "@ekaterina_nov"
        tag.font = UIFont.systemFont(ofSize: 13)
        tag.textColor = .ypGray
        return tag
    } ()
    
    private var userText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Hello,world!"
        text.font = UIFont.systemFont(ofSize: 13)
        text.textColor = .ypWhite
        return text
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(Self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfileContent()
        addConstraints()
    }
    
    private func addProfileContent() {
        view.addSubview(userPick)
        view.addSubview(userName)
        view.addSubview(userTag)
        view.addSubview(userText)
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
    @objc
    private func didTapLogoutButton(){
        print("tap")
    }
}






