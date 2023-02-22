//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Сергей Андреев on 15.02.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth()  throws {
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        // Ввести данные в форму
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("пароль")
        webView.swipeUp()
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        XCTAssert(loginTextFiled.waitForExistence(timeout: 5))
        
        loginTextFiled.tap()
        loginTextFiled.typeText("почта")
        webView.swipeUp()
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() {
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
           // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        
        sleep(2)
           // Поставить лайк в ячейке верхней картинки
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
           // Отменить лайк в ячейке верхней картинки
        sleep(2)
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
           // Нажать на верхнюю ячейку
        cellToLike.tap()
           // Подождать, пока картинка открывается на весь экран
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
           // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
           // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
           // Вернуться на экран ленты
        let navBackWhiteButton = app.buttons["nav back button white"]
        navBackWhiteButton.tap()
    }
    
    func testProfile() {
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
            // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
            // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["имя пользователя"].exists)
        XCTAssertTrue(app.staticTexts["@тег"].exists)
            // Нажать кнопку логаута
        app.buttons["logout button"].tap()
            // Проверить, что открылся экран авторизации
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
