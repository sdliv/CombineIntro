//
//  ApiCaller.swift
//  CombineIntro
//
//  Created by Sean Livingston on 12/7/22.
//

import Foundation
import Combine

class ApiCaller {
    static let shared = ApiCaller()
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promise(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }
        }
    }
}
