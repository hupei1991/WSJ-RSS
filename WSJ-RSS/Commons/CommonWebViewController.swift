//
//  CommonWebViewController.swift
//  WSJ-RSS
//
//  Created by Practice on 10/21/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import UIKit
import WebKit

class CommonWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var url: URL?
    var webView: WKWebView!
    var progressView: UIProgressView!
    var previousProgress: Float = 0.0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(_ url: URL) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
//        navController.navigationBar.tintColor = .blue
//        buttonItem.tintColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let wkConfiguration = WKWebViewConfiguration()
        wkConfiguration.preferences = preferences
        
        self.webView = WKWebView(frame: self.view.frame, configuration: wkConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.progressView = UIProgressView()
        self.progressView.progressViewStyle = .bar
        self.progressView.setProgress(0.0, animated: false)
        self.previousProgress = self.progressView.progress
        self.view.addSubview(self.progressView)
        self.view.bringSubviewToFront(self.progressView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = self.url else {
            print("Error: url not set")
            let alert = UIAlertController(title: "Failure", message: "Failed to this feed in your system browser", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(
                UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    _ in
                    self.navigationController?.popViewController(animated: true)
                }
            )
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let request = URLRequest(url: url)
        print("Loading URL \(url)")
        webView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressView.progress = 0.0
        webView.stopLoading()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        self.progressView.frame = CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.origin.x, y: self.view.safeAreaLayoutGuide.layoutFrame.origin.y, width: UIScreen.main.bounds.width, height: 20)
    }
}

//MARK: Observers
extension CommonWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            let currentProgress = Float(webView.estimatedProgress)
            if currentProgress > previousProgress {
                progressView.setProgress(currentProgress, animated: true)
                previousProgress = progressView.progress
            }
        }
    }
}

//MARK: WebView Delegates
extension CommonWebViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {
            print("Error: Unable to get current url form WebView")
            return
        }
        
        print("webView DidFinish: currentUrl: \(url)")
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.textAlignment = .center
        label.text = webView.title
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        container.addSubview(label)
        self.navigationItem.titleView = container
        
        let safariLogo = UIImage(systemName: "safari")
        let config = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .regular)
        safariLogo?.withConfiguration(config)
        let openInSafariBarButtonItem = UIBarButtonItem(image: safariLogo, style: .plain, target: self, action: #selector(self.openInExternal(_:)))
        openInSafariBarButtonItem.tintColor = self.navigationController?.view.tintColor ?? UIColor.systemBlue
        self.navigationItem.rightBarButtonItem = openInSafariBarButtonItem
    }
    
}

//MARK: Actions
extension CommonWebViewController {
    @objc private func openInExternal(_ sender: Any) {
        guard let url = self.url else {
            print("Error: Url not set, this should not happen")
            return
        }
        UIApplication.shared.open(url, options: [:]) {
            success in
            if success {
                print("Successfully opened the \(url.absoluteString) in an external browser")
            } else {
                print("Error: Failed to open \(url.absoluteString) in an external browser")
                let alert = UIAlertController(title: "Failure", message: "Failed to this feed in your system browser", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
