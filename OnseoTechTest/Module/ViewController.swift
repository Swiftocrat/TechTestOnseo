//
//  ViewController.swift
//  OnseoTechTest
//
//  Created by Yaroslav Vushnyak on 20.07.2020.
//  Copyright © 2020 Yaroslav Vushnyak. All rights reserved.
//

import UIKit
import WebKit


class ViewController: View {
  
  private lazy var webView:WKWebView = {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    let web = WKWebView(frame: view.frame, configuration: configuration)
    web.navigationDelegate = self
    web.uiDelegate = self
    
    return web
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = ParseViewModel()
    viewModel?.viewDataSource = self
    viewModel?.viewModelDataSource = self
    view.addSubview(webView)
    viewModel?.refreshData()
  }


}

extension ViewController: ViewDataSource, ViewModelDataSource {
  func openUrl() -> String {
    return "http://bingoplayground.test.bingosys.net/native.xml"
  }
  
  func openUrl(_ url: String) {
    guard let url = URL(string: url) else { return }
    DispatchQueue.main.async {
      self.webView.load(URLRequest(url: url))
    }
  }
}

extension ViewController: WKUIDelegate, WKNavigationDelegate {
  
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("window.alert('Success');", completionHandler: nil)
  }
  
  
  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let alertController = UIAlertController(title: message,message: nil,preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {_ in completionHandler()})
    self.present(alertController, animated: true, completion: nil)
  }
}

