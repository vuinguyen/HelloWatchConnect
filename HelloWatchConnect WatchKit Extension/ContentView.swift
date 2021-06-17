//
//  ContentView.swift
//  HelloWatchConnect WatchKit Extension
//
//  Created by Vui Nguyen on 6/16/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModelWatch()
    var body: some View {
        VStack {
            Text("Message received: ")
            Text(self.model.messageText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
