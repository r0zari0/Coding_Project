//
//  ViewController.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/17/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("Deinit \(Self.self)")
        
    }
}
