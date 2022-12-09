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






/*  func addConstraints() {
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
 userText.leadingAnchor.constraint(equalTo: userTag.leadingAnchor)
 ])
 }*/

/* let label1 = UILabel()
 let label2 = UILabel()
 let label3 = UILabel()
 
 label1.text = "Первый"
 label2.text = "Второй"
 label3.text = "Третий"
 
 label1.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(label1)
 
 label2.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(label2)
 
 label3.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(label3)
 
 NSLayoutConstraint.activate([
     label1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
     label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20),
     label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
     label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
     label3.leadingAnchor.constraint(equalTo: label2.leadingAnchor)
 ])

 
 
 
 private var nameLabel: UILabel?

    
    let profileImage = UIImage(systemName: "person.crop.circle.fill")
    let profileView = UIImageView(image: profileImage)
    profileView.tintColor = .gray
    profileView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(profileView)
    profileView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    
    let nameLabel = UILabel()
    nameLabel.text = "Name"
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameLabel)
    nameLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 20).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor).isActive = true
    self.nameLabel = nameLabel
    
    let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                       target: self,
                                       action: #selector(Self.didTapButton))
    button.tintColor = .red
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    button.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
    button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
*/
