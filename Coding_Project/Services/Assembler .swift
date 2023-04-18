//
//  Assembler .swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/14/23.
//

import UIKit

class Assembler {
    
    private let container: Container = Container.createContainer()

    func createDoorVC(navigator: NavigatorProtocol) -> UIViewController {
        let doorVC = DoorsViewController(navigator: navigator)

        return doorVC
    }
}
