//
//  TimerView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/30.
//

import Combine
import SwiftUI

struct TimerView: View {
//    @State var futureDate: Date
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerAmount: Int
    @State var timeRemaining: Int = 0
    @State var title: String
    @State var isOver: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("\(title)까지 남은 시간")
            Text(convertSecondsToTime(timeInSeconds: timeRemaining))
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        timeRemaining = 0
                        isOver = true
                    }
                }
                .font(.title)
            if isOver {
                Button {
                    dismiss()
                } label: {
                    Text("돌아가기")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            let targetTime = Date().addingTimeInterval(TimeInterval(timerAmount))
            calcRemain(targetTime: targetTime)
        }
    }

    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    func calcRemain(targetTime: Date) {
        let remainSeconds = Int(targetTime.timeIntervalSince(Date()))
        timeRemaining = remainSeconds
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerAmount: 5, title: "afadfas")
    }
}
