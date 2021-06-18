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
            Text("Status: ")
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
                if self.model.phoneState == .reachable, let session = self.model.session {
                    // depending on state, send appropriate message?
                    session.sendMessage(["message" : self.messageText], replyHandler: { (reply) in
                       // self.model.logInLogout(reply: reply)
                       // print("received message from watch")
                    }, errorHandler: { (error) in
                        print(error.localizedDescription)
                    })
                }
                self.model.logInLogout(reply: nil)
            }) {
                Text(self.model.phoneState == .loggedIn ? "Logout" : "Login")
            }
        }
    }
}
