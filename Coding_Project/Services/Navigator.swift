//
//  Navigator.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/14/23.
//

import UIKit

protocol NavigatorProtocol {
    func showDoorVC() -> UIViewController
}

class Navigator: NavigatorProtocol {

    private let assembler: Assembler = Assembler()

    func showDoorVC() -> UIViewController {
        assembler.createDoorVC(navigator: self)
    }
}
