//
//  ProfileViewTests.swift
//  ImageFeedUnitTests
//
//  Created by Сергей Андреев on 15.02.2023.
//
// Привет! Бльое спасибо за обратную связь, внес правки, по fatal error и другим моментам обязательно займусь в грядущее свободное время, также спасибо за ссылки, почитаю. Странно, что не соббрались тесты, провел рокировку, надееюсь, что это поможет)))

import XCTest
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func showLogoutAlert() -> UIAlertController {
        UIAlertController()
    }
}

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
