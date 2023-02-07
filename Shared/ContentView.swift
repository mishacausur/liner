//
//  ContentView.swift
//  Shared
//
//  Created by Misha Causur on 07.02.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Metal()
                .border(.pink, width: 2)
            Text("Metal")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
