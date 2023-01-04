//
//  ContentView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/23.
//

import SwiftUI

struct Impulse: Codable, Hashable {
    var title: String
    var minute: Int
}

class ImpulseStore: ObservableObject {
    init() {
        if let impulsies = UserDefaults.standard.data(forKey: "impulsies") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Impulse].self, from: impulsies) {
                self.impulsies = decoded
                return
            }
        }
        self.impulsies = []
    }

    @Published var impulsies = [Impulse]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(impulsies) {
                UserDefaults.standard.set(encoded, forKey: "impulsies")
            }
        }
    }
}

struct ContentView: View {
    @State private var newImpulse: String = ""
    @State private var newMinute: String = ""
    @FocusState private var isFocused: Bool
    @ObservedObject private var impulseArr = ImpulseStore()

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(impulseArr.impulsies, id: \.self) { (item: Impulse) in
                        listItem(title: item.title, minute: item.minute)
                    }
                    .onDelete(perform: removeList)
                    .onMove(perform: moveList)
                }

                Section(header: Text("새 충동")) {
                    Group {
                        TextField("충동을 입력", text: $newImpulse)
                            .focused($isFocused)
                            .disableAutocorrection(true)

                        TextField("시간(분)을 입력", text: $newMinute)
                            .focused($isFocused)
                            

                        Button("Add") {
                            if newImpulse != "" || newMinute != "" {
                                impulseArr.impulsies.append(Impulse(title: newImpulse, minute: Int(newMinute)!))
                                newMinute = ""
                                newImpulse = ""
                                isFocused = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("충동 선택하기")
        }
        .padding()
    }
    

    func removeList(at offsets: IndexSet) {
        impulseArr.impulsies.remove(atOffsets: offsets)
//        saveImpulsies(data: impulseArr.impulsies)
    }

    func moveList(from fromOffSets: IndexSet, to toOffSets: Int) {
        impulseArr.impulsies.move(fromOffsets: fromOffSets, toOffset: toOffSets)
//        saveImpulsies(data: impulseArr.impulsies)
    }

    func saveImpulsies(data: [Impulse]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: "impulsies")
        }
    }

    @ViewBuilder
    private func listItem(title: String, minute: Int) -> some View {
        NavigationLink {
            TimerView(timerAmount: minute * 60, title: title)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text("- \(minute)분")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
