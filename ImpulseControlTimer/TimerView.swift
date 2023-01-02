//
//  TimerView.swift
//  ImpulseControlTimer
//
//  Created by hwikun on 2023/01/02.
//

import SwiftUI

struct TimerView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerAmount: Int
    @State var timeRemaining: String = ""
    @State var title: String
    @State var isOver: Bool = false
    @State var targetTime: Date = .init()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("\(title)까지 남은 시간")
            Text(timeRemaining)
                .font(.title)
            if isOver {
                Button {
                    dismiss()
                } label: {
                    Text("돌아가기")
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            targetTime = Calendar.current.date(byAdding: .second, value: timerAmount, to: Date()) ?? Date()
        }
        .onReceive(timer) { _ in
            calcRemain(targetTime: targetTime)
        }
    }

    func calcRemain(targetTime: Date) {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: targetTime)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        if minute == 0 && second == 0 {
            isOver = true
            self.timer.upstream.connect().cancel()
        }
        timeRemaining = String(format: "%02i:%02i", minute, second)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerAmount: 3, title: "afdsaf")
    }
}
