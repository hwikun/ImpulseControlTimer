//
//  TimerView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/30.
//

import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    let notiCenter = UNUserNotificationCenter.current()
    init() {}

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }

    func scheduleNotification(time: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time is Over!!!"
        content.body = "Enjoy!!!"
        content.sound = .default
        content.badge = 1

        let trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)

        let request = UNNotificationRequest(identifier: "timeOut", content: content, trigger: trigger)
        notiCenter.add(request)
    }

    func cancelNotification() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
}

struct TimerView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerAmount: Int
    @State var timeRemaining: String = ""
    @State var title: String
    @State var isOver: Bool = false
    @State var targetTime: Date = .init()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var manager = NotificationManager()

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
                    self.manager.cancelNotification()
                } label: {
                    Text("돌아가기")
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            targetTime = Date(timeIntervalSinceNow: TimeInterval(timerAmount))
            self.manager.requestAuthorization()
            self.manager.scheduleNotification(time: timerAmount)
        }
    }

    func calcRemain(targetTime: Date) {
        let remaining = Int(targetTime.timeIntervalSince(Date()))
        var minute = (remaining % 3600) / 60
        var second = remaining % 60
        if minute <= 0 && second <= 0 {
            isOver = true
            timer.upstream.connect().cancel()
            minute = 0
            second = 0
        }
        timeRemaining = String(format: "%02i:%02i", minute, second)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerAmount: 3, title: "afdsaf")
    }
}
