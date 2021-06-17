//
//  ViewModelPhone.swift
//  HelloWatchConnect
//
//  Created by Vui Nguyen on 6/16/21.
//

import Foundation
import WatchConnectivity
import Combine


protocol printEnum {
    var description: String { get }
}

enum PhoneState: printEnum {
    case notreachable
    case reachable

    var description: String {
        switch self {
        case .notreachable:
            return "Not Reachable"
        case .reachable:
            return "Reachable"
        }
    }
}

class ViewModelPhone: NSObject, WCSessionDelegate, ObservableObject {
    @Published var phoneState: PhoneState = .notreachable

    var session: WCSession?

    init(session: WCSession = .default){
        super.init()
        if WCSession.isSupported() {
            self.session = session
            self.session?.delegate = self
            session.activate()
            _ = isReachable()
        } 
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState{
        case .activated:
            print("Phone WCSession Activated")
        case .notActivated:
            print("Phone WCSession Not Activated")
        case .inactive:
            print("Phone WCSession Inactive")
        @unknown default:
            fatalError()
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session went inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated")
    }
}


extension ViewModelPhone {
    func isReachable() -> Bool {
        var reachable = false
        if let session = session {
            reachable = session.isReachable
        }
        phoneState = reachable ? .reachable : .notreachable
        return reachable
    }
}

