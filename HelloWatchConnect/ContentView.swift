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
    @State var reachable = "No"
    @State var messageText = ""
    var body: some View {
        VStack(alignment: .center) {
            Text("Status: ")
                .font(.title)
            Text("\(self.model.phoneState.description)")
                .padding()
        
            TextField("Enter Password", text: $messageText)
            Button(action: {
                if let session = self.model.session {
                    session.sendMessage(["message" : self.messageText], replyHandler: nil) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) {
                Text("Login")
            }
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
