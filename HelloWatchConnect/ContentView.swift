//
//  ContentView.swift
//  HelloWatchConnect
//
//  Created by Vui Nguyen on 6/16/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var model : ViewModelPhone

    var body: some View {
        VStack(alignment: .center) {
            Text("Status:")
                .font(.title)
            Text("\(self.model.phoneState.description)")
                .padding()

            LoginView()
                .disabled(self.model.phoneState == .notreachable)
        }
        .multilineTextAlignment(.center) // end VStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModelPhone())
            .previewDevice("iPhone 12")
    }
}

struct LoginView: View {
    @EnvironmentObject var model : ViewModelPhone
    @State var messageText = ""
    var body: some View {
        VStack {
            TextField("Enter Password", text: $messageText)
                .disabled(self.model.phoneState != .reachable)
            Button(action: {
                // Do when in reachable state
                if self.model.phoneState == .reachable, let session = self.model.session {
                    session.sendMessage(["login" : self.messageText], replyHandler: { (reply) in
                        // confirm that message was received on watch side
                        if reply["login"] != nil {
                            clearTextBoxChangeLogStatus()
                        }
                    }, errorHandler: { (error) in
                        print(error.localizedDescription)
                    })
                // Do when logged in
                } else if self.model.phoneState == .loggedIn, let session = self.model.session {
                    session.sendMessage(["logout" : true], replyHandler: { (reply) in
                        // confirm that message was received on watch side
                        if let didLogout = reply["logout"] as? Bool {
                            if didLogout {
                                clearTextBoxChangeLogStatus()
                            }
                        }
                    }, errorHandler: { (error) in
                        print(error.localizedDescription)
                    })
                }

            }) {
                Text(self.model.phoneState == .loggedIn ? "Logout" : "Login")
            }
        }
    }

    func clearTextBoxChangeLogStatus() {
        messageText = ""
        self.model.logInLogout()
    }
}
