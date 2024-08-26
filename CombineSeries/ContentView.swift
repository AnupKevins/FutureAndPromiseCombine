//
//  ContentView.swift
//  CombineSeries
//
//  Created by Anup kumar sahu on 30/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = FuturesAndPromisesViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(vm.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
