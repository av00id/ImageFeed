//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Сергей Андреев on 21.02.2023.
//
/* Еще раз приветствую Данил. Прошу прощения за то, что пропустил указанные ранее ошибки. Дело в том, что и тесты, и приложение оба раза у меня запускались без проблем, поэтому я спокойно отправил неудачные исправления на ревью, поторопился. В этот раз я поступил радикально - просто снес лишние таргеты, связанные с unit тестам (так случилось, что были созданы лишние, из-за этого и произошла путаница), создал заново и перенес код, все работает корректно. Также внес правки в слабую ссылку, теперь все должно быть в порядке, приложение также собирается, все работает как и работало ранее. Очень надеюсь, что в этот раз оказался прав, в академ из-за таких моментов уходить точно не хочется( */
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) // behaviour verification
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper() //Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
       // let configuration = AuthConfiguration.self
        let authHelper = AuthHelper()
        
        //when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(AuthConfiguration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(AuthConfiguration.accessKey))
        XCTAssertTrue(urlString.contains(AuthConfiguration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(AuthConfiguration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}


