//
//  ViewModel.swift
//  OnseoTechTest
//
//  Created by Yaroslav Vushnyak on 21.07.2020.
//  Copyright © 2020 Yaroslav Vushnyak. All rights reserved.
//

import Foundation
import UIKit



class ParseViewModel:ViewModel {
  var view:View?
  private var elementName: String = String()
  private var bundle: String = String()

  private var parser: XMLParser? {
    didSet {
      parser?.delegate = self
      parser?.parse()
    }
  }
  
  override func refreshData() {
    if let url = viewModelDataSource?.openUrl() {
      let request = URLRequest(url: URL(string: url)!)
      URLSession.shared.dataTask(with: request) { (data, response, error) in
         guard let data = data, error == nil else {
               print(error as Any)
               return
           }

         self.parser = XMLParser(data: data)
       }.resume()
    }
  }
  
}


extension ParseViewModel: XMLParserDelegate {
  public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    self.elementName = elementName
  }
  
  public func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let searchedBundle = "com.888bingo"
    if !data.isEmpty {
      if self.elementName == "bundle" {
        if data.contains(searchedBundle) {
          bundle += data
        }
      }
      if self.elementName == "appURL" && bundle.contains(searchedBundle) {
        viewDataSource?.openUrl(data)
      }
    }
  }
}

