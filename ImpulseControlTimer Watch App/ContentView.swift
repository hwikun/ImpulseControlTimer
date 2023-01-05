//
//  ContentView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var newImpulse: String = ""
    @State private var newMinute: String = ""
    @ObservedObject private var impulseArr = ImpulseStore()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("타이머 리스트")) {
                    ForEach(impulseArr.impulsies, id: \.self) { (item: Impulse) in
                        listItem(title: item.title, minute: item.minute)
                    }
                    .onDelete { impulseArr.impulsies.remove(atOffsets: $0) }
                    .onMove { impulseArr.impulsies.move(fromOffsets: $0, toOffset: $1) }
                }

                Section(header: Text("새 타이머 추가")) {
                    TextField("충동을 입력", text: $newImpulse)

                    TextField("시간(분)을 입력", text: $newMinute)
                }

                Button("Add") {
                    if newImpulse != "" || newMinute != "" {
                        impulseArr.impulsies.append(Impulse(title: newImpulse, minute: Int(newMinute)!))
                        newMinute = ""
                        newImpulse = ""
                    }
                }
            }
        }
        .padding()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
