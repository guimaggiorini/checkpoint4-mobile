//
//  NotificationService.swift
//  Todolist
//
//  Created by Arthur Mariano on 19/09/25.
//

import Foundation
import UserNotifications

@Observable
class NotificationService {
    var hasPermission = false
    var permissionStatus: UNAuthorizationStatus = .notDetermined
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        Task {
            await checkPermissionStatus()
        }
    }
    
    private func checkPermissionStatus() async {
        let settings = await notificationCenter.notificationSettings()
        permissionStatus = settings.authorizationStatus
        hasPermission = settings.authorizationStatus == .authorized
    }
    
    private func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            
            await checkPermissionStatus()
            return granted
        } catch {
            print("Error requesting permition: \(error)")
            return false
        }
    }
    
    func ensurePermission() async -> Bool {
        switch permissionStatus {
        case .notDetermined:
            return await requestPermission()
        case .denied, .provisional, .ephemeral:
            return false
        case .authorized:
            return true
        @unknown default:
            return false
        }
    }
    
    func scheduleNotification(
        for date: Date,
        title: String,
        body: String,
        identifier: String? = nil,
    ) async -> Bool  {
        guard await ensurePermission() else { return false }
        guard date > Date() else { return false }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let notificationId = identifier ?? UUID().uuidString
        
        let request = UNNotificationRequest(
            identifier: notificationId,
            content: content,
            trigger: trigger
        )
        
        do {
            try await notificationCenter.add(request)
            return true
        } catch {
            return false
        }
    }
}
