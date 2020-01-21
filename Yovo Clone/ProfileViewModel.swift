//
//  ProfileViewModel.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 21/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    internal var user: User?
    
    func parseJson() {
        if let path = Bundle.main.path(forResource: "userprofile", ofType: "json") {
            var data = Data()
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch let error {
                // handle error
                debugPrint("Error reading json file", error)
            }
            do {
                let decoder = JSONDecoder()
                
                self.user = try decoder.decode(User.self, from: data)
                
            } catch let err {
                // handle error
                debugPrint("Error creating json object", err)
            }
        }
    }

}
