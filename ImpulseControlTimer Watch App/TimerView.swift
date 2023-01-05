//
//  TimerView.swift
//  ImpulseControlTimer Watch App
//
//  Created by hwikun on 2022/12/30.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @State var timerAmount: Int
    @State var title: String
    @State var timeRemaining: String = ""
    @State var isOver: Bool = false
    @State var targetTime: Date = .init()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var manager = NotificationManager()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
        .padding()
        .navigationBarBackButtonHidden()
        .onAppear {
            targetTime = Date(timeIntervalSinceNow: TimeInterval(timerAmount))
            self.manager.requestAuthorization()
            self.manager.scheduleNotification(time: timerAmount)
        }
    }

    func calcRemain(targetTime: Date) {
        let remaining = Int(targetTime.timeIntervalSince(Date()))
        var minute = remaining / 60
        var second = remaining % 60
        if minute <= 0 && second <= 0 {
            timer.upstream.connect().cancel()
            isOver = true
            minute = 0
            second = 0
        }
        timeRemaining = String(format: "%02i:%02i", minute, second)
    }
}

class NotificationManager: ObservableObject {
    let notiCenter = UNUserNotificationCenter.current()

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

        let trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)

        let request = UNNotificationRequest(identifier: "timeOut", content: content, trigger: trigger)
        notiCenter.add(request)
    }

    func cancelNotification() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerAmount: 3, title: "afdsaf")
    }
}
