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
//            Text("Status: ")
//                .font(.title)
            //Text("\(self.model.phoneState.description)")
          //  Text(self.model.isReachable() ? self.model.phoneState.description : self.model.phoneState.description)
          //      .font(.title2)

            Text("Reachable: \(reachable)")
                .bold()
            Button(action: {
                if self.model.isReachable() {
                    self.reachable = "Yes"
                }
                else{
                    self.reachable = "No"
                }

            }) {
                Text("Update Status")
            }
                .padding()


            TextField("Input your message", text: $messageText)

            Button(action: {
                if let session = self.model.session {
                    session.sendMessage(["message" : self.messageText], replyHandler: nil) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) {
                Text("Send Message")
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
