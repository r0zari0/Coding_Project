//
//  Container.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/14/23.
//

import Foundation

struct Container {

    let coreDataService: CoreDataProtocol

    static func createContainer() -> Container {
        let coreDataService: CoreDataProtocol = CoreDataService()

        return Container(coreDataService: coreDataService)
    }
}
