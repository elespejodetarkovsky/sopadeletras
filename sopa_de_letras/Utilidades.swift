//
//  Connection.swift
//  sopa_de_letras
//
//  Created by Mati on 27/11/2019.
//  Copyright © 2019 Mati. All rights reserved.
//

import Foundation
import Alamofire

class Utilidades {
   
    
    static let url = "https://store.apicultur.com/api/corrige-palabra/1.0.0"

    static let headers: HTTPHeaders = [
      "Authorization": "Bearer uHS_7Q2Esg7XsUKNsaqFx2sB1mca",
      "Accept": "application/json"
    ]

    static func consulta (word: String, completion:@escaping(_ result: Bool) -> Void) -> Void {
        
        var wordUrl = url + "/" + word
        
        
        print(wordUrl)
        
        AF.request(wordUrl, headers: headers).responseJSON { response in
            
            //print(response.response) // http url response
            print("la respuesta es: ", response.result)  // response serialization result
            
            let correct = response.description.contains("error")
            
            completion(!correct)
            
        }
    }
    
    
}
