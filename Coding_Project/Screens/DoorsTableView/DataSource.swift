//
//  DataSource.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/17/23.
//

import Foundation

// MARK: - DoorsTableViewDataSourceProtocol

protocol DoorsTableViewDataSourceProtocol {
    var countDoors: Int { get }

    func getDoor(with row: Int) -> Door
    func changeStatusDoor(with row: Int)
    func getMockDate()
}

// MARK: - DoorsData: DoorsTableViewDataSourceProtocol

class DoorsData: DoorsTableViewDataSourceProtocol {
    private var doors: [Door] = []

    var countDoors: Int {
        doors.count
    }
    
    func getMockDate() {
        doors = Door.getMockData()
    }

    func getDoor(with row: Int) -> Door {
        doors[row]
    }

    func changeStatusDoor(with row: Int) {
        doors[row].changeDoorStatus()
    }
}
