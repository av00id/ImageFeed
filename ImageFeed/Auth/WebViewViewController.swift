//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 16.12.2022.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc:WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc:WebViewViewController)
}

final class WebViewViewController: UIViewController  {
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
        updateProgress()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}


extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView:WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ){
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.nativePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        else {
            return nil
        }
        return codeItem.value
    }
}

