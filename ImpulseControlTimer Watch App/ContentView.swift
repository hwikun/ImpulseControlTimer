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
    @State var goToMain: Bool = false
    

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(impulseArr ?? [""], id: \.self) { item in
                        NavigationLink {
                            TimerView(timerAmount: 3, title: item)
                        } label: {
                            HStack {
                                Text(item)
                                Spacer()
                                Text("- 10분")
                            }
                        }
                    }
                    .onDelete(perform: removeList)
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
            .navigationTitle("충동 선택하기")
        }
    }

    func removeList(at offsets: IndexSet) {
        impulseArr!.remove(atOffsets: offsets)
        UserDefaults.standard.set(impulseArr, forKey: "impulseArr")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
