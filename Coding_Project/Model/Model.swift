//
//  Model.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/15/23.
//

import Foundation

class Door {
    let title: String
    let subTitle: String
    var status: DoorStatus

    init(title: String, subTitle: String, status: DoorStatus) {
        self.title = title
        self.subTitle = subTitle
        self.status = status
    }

    enum DoorStatus {
        case locked
        case unlocked
        case unlocking

        var text: String {
            switch self {
            case .locked:
                return "Locked"
            case .unlocked:
                return "Unlocked"
            case .unlocking:
                return "Unlocking..."
            }
        }

        var mainImageName: String {
            switch self {
            case .locked:
                return "icon_locked_status"
            case .unlocked:
                return "icon_unlocked_status"
            case .unlocking:
                return "icon_unlocking_status"
            }
        }

        var doorImageName: String {
            switch self {
            case .locked:
                return "icon_locked_door"
            case .unlocked:
                return "icon_unlocked_door"
            case .unlocking:
                return ""
            }
        }

        var opacity: Float {
            switch self {
            case .locked:
                return 1
            case .unlocking:
                return 0.17
            case .unlocked:
                return 0.5
            }
        }

        var unlockIsEnable: Bool {
            switch self {
            case .locked:
                return true
            case .unlocking:
                return false
            case .unlocked:
                return false
            }
        }
    }

    func changeDoorStatus() {
        switch status {
        case .locked:
            status = .unlocked
        case .unlocked:
            status = .unlocking
        case .unlocking:
            status = .locked
        }
    }
}

extension Door {
    static func getMockData() -> [Door] {
        let count = Int.random(in: 1...20)
        let doors = (0...count).map { _ in
            let randomTitle = ["Front Door", "Home Door", "Work Door"].randomElement() ?? "Front Door"
            let randomSubTitle = ["Front", "Home", "Work"].randomElement() ?? "Front"
            let status = Door.DoorStatus.locked

            return Door(title: randomTitle, subTitle: randomSubTitle, status: status)
        }

        return doors
    }
}
