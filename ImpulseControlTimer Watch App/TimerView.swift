//
//  TimerView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/30.
//

import Combine
import SwiftUI

struct TimerView: View {
    let date = Date()
    @State var timeRemaining: Int = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(convertSecondsToTime(timeInSeconds: timeRemaining))
            .font(.largeTitle)
            .onReceive(timer) { _ in
                timeRemaining -= 1
            }
            .onAppear {
                calcRemain()
            }
    }
        

    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds - hours * 3600) / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    func calcRemain() {
        let calendar = Calendar.current
        let targetTime: Date = calendar.date(byAdding: .second, value: 600, to: date, wrappingComponents: false) ?? Date()
        let remainSeconds = Int(targetTime.timeIntervalSince(date))
        timeRemaining = remainSeconds
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
