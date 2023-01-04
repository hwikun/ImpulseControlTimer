//
//  TimerView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/30.
//

import Combine
import SwiftUI
import UserNotifications

struct TimerView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerAmount: Int
    @State var timeRemaining: String = ""
    @State var title: String
    @State var isOver: Bool = false
    @State var targetTime: Date = .init()
    @Environment(\.dismiss) private var dismiss
    let notificationCenter = UNUserNotificationCenter.current()

    var body: some View {
        VStack {
            Text("\(title)까지 남은 시간")
            Text(timeRemaining)
                .font(.title)
                .onReceive(timer) { _ in
                    calcRemain(targetTime: targetTime)
                }
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
            targetTime = Calendar.current.date(byAdding: .second, value: timerAmount, to: Date()) ?? Date()
        }
    }

    func calcRemain(targetTime: Date) {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: targetTime)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        if minute == 0 && second == 0 {
            isOver = true
            timer.upstream.connect().cancel()
        }
        timeRemaining = String(format: "%02i:%02i", minute, second)
    }

    private func generateUserNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print(error)
            } else {
                if granted {
                    let content = UNMutableNotificationContent()
                    content.title = "Time is Over"
                    content.body = "Enjoy!!!"
                    content.badge = 1
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
                    let request = UNNotificationRequest(identifier: "Sample Notification", content: content, trigger: trigger)
                    self.notificationCenter.add(request, withCompletionHandler: nil)
                } else {
                    print("Not Granted")
                }
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerAmount: 3, title: "afadfas")
    }
}
