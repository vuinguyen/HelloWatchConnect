//
//  ViewModelWatch.swift
//  HelloWatchConnect WatchKit Extension
//
//  Created by Vui Nguyen on 6/16/21.
//

import Foundation
import WatchConnectivity

protocol printEnum {
    var description: String { get }
}

enum WatchState: printEnum {
    case notreachable
    case reachable
    case loggedIn

    var description: String {
        switch self {
        case .notreachable:
            return "Not Reachable"
        case .reachable:
            return "Reachable"
        case .loggedIn:
            return "Logged In"
        }
    }
}

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject {
    @Published var watchState: WatchState = .notreachable
    @Published var messageText = ""

    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        _ = isReachable()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.watchState = session.isReachable ? .reachable : .notreachable
            self.messageText = ""
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let loginMessage = message["login"] as? String {
                self.messageText = loginMessage
                self.watchState = .loggedIn
                replyHandler(message)
            } else if let doLogout = message["logout"] as? Bool {
                if doLogout {
                    self.messageText = ""
                    self.watchState = .reachable
                    replyHandler(message)
                }
            }
        }
    }
}

extension ViewModelWatch {
    func isReachable() -> Bool {
        DispatchQueue.main.async {
            self.watchState = self.session.isReachable ? .reachable : .notreachable
        }
        return session.isReachable
    }
}
