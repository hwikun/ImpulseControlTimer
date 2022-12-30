//
//  ContentView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var newImpulse: String = ""
    @State private var impulseArr = UserDefaults.standard.stringArray(forKey: "impulseArr") ?? nil
    var createImpulseArr: Void = UserDefaults.standard.set(["먹기", "자기", "놀기"], forKey: "impulseArr")

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(impulseArr ?? [""], id: \.self) { item in
                        listItem(title: item)
                    }
                }

                Section(header: Text("새 충동")) {
                    TextField("충동을 입력", text: $newImpulse)
                        .disableAutocorrection(true)
                        .onSubmit {
                            impulseArr?.append(newImpulse)
                            UserDefaults.standard.set(impulseArr, forKey: "impulseArr")
                            newImpulse = ""
                        }
                }
            }
            .navigationTitle("조절하고 싶은 충동")
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func listItem(title: String, timer: Int = 10) -> some View {
        NavigationLink {
            TimerView()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text("- \(timer)분")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
