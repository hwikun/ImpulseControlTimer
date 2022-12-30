//
//  ContentView.swift
//  ImpulseControlTimer
//
//  Created by hwikun on 2022/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var impulse: String = ""
    var value: Int = 1000
    
    var body: some View {
        VStack {
            Text("Control your Impulse")
                .font(.system(size: 15))
            
            Form {
                TextField(
                        "enter your impuse",
                        text: $impulse
                    )
            }
            
            
            Button {
                
            } label: {
                Text("Confirm")
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
