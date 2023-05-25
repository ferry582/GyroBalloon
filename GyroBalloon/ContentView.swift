//
//  ContentView.swift
//  GyroBalloon
//
//  Created by Ferry Dwianta P on 25/05/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene = HomeScene()
    
    var body: some View {
        NavigationStack() {
            
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            .onAppear {
                playSound(sound: "bgMusic", type: "m4a", loop: -1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
