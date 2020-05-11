//
//  ViewController.swift
//  localNotification
//
//  Created by 杨丽婧 on 2020/4/29.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    func setNotify(date: Date?, center: UNUserNotificationCenter, str: String?, type: String?, id: String) -> () {
        
        var title = "None"
        
        if type != nil {
            if type == "Class" {
                title = "You have a class in 10 mintue"
            }
            else if type == "Task" {
                title = "You have a task due tomorrow"
            }
            else {
                return
            }
        }
        
        //create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        if str != nil {
            content.body = str!
        }
        
        //create the trigger
        //let date = Date().addingTimeInterval(10)
        
        if date == nil {
            return
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create the request
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //register the request with the notification center
        center.add(request) { (error) in
            if error != nil {
                print("register request failed")
            }
            
        }
        
    }
    
    //input is startTime/endTime e.g. 13:50
    //output is a Date with formatted string: Date + "T" + time + "00:00"
    func timeConverter(date: Date? ,time: String?) -> Date {
        
        if time == nil || date == nil {
            return Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'"
        let dateStr = formatter.string(from: date!)
        let timeStr = time!+":00+00:00"
        let str = dateStr + timeStr
        
        //convert formatted string back to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: str)!
    }
    
    //save all weekdays(class day) into a Date list
    //time interval: startDate ~ endDate
    func getWeekdayList(startDate: Date?, endDate: Date?, weekdays: String?, startTime: String?) -> [Date] {
        
        if startDate == nil || endDate == nil || weekdays == nil || startTime == nil {
            return []
        }
        
        //convert weekday patterns into numbers
        //targetWeekdays is the matched weekdays from startDate to endDate
        var targetWeekdays: [Int] = []
        switch weekdays! {
        case "M":
            targetWeekdays = [2]
        case "T":
            targetWeekdays = [3]
        case "W":
            targetWeekdays = [4]
        case "TH":
            targetWeekdays = [5]
        case "F":
            targetWeekdays = [6]
        case "Sa":
            targetWeekdays = [7]
        case "Su":
            targetWeekdays = [1]
        case "MW":
            targetWeekdays = [2, 4]
        case "TTH":
            targetWeekdays = [3, 5]
            
        default:
            targetWeekdays = []
        }
        
        var resultList: [Date] = []
        let calendar = Calendar.current
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        
        let startDay = calendar.component(.weekday, from: startDate!)
        
        //if startDay is matched, add it into the result list
        if targetWeekdays.contains(startDay) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'"
            let dateStr = formatter.string(from: startDate!)
            let timeStr = startTime!+":00+00:00"
            let str = dateStr + timeStr
            
            //convert formatted string back to date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            resultList.append(dateFormatter.date(from: str)!)
            
        }
        
        //iterate the dates from startDate to endDate
        calendar.enumerateDates(startingAfter: startDate!, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date {
                if date <= endDate! {
                    let weekday = calendar.component(.weekday, from: date)
                    
                    if targetWeekdays.contains(weekday) {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'"
                        let dateStr = formatter.string(from: date)
                        let timeStr = startTime!+":00+00:00"
                        let str = dateStr + timeStr
                        
                        //convert formatted string back to date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        resultList.append(dateFormatter.date(from: str)!)
                    }
                }
                else {
                    stop = true
                }
            }
        }
        
        return resultList
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //-------------------------
        
        let center = UNUserNotificationCenter.current()
        
        //request user authorization for the notification
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil {
                print("request authorization error")
            }
        }
        
        /*
         
         For class notify,
         date = time before class begins, I set 10 minutes earlier
         str = course title + when + where
         type = "Class"
         
         For task notify,
         date = time before the task dues, I set 1 day earlier
         str = task content
         type = "Task"
         
         */
        
        var date = Date().addingTimeInterval(10)
        let str = "CIS651 6:00~8:00 CST105"
        let type = "Class"
        
        setNotify(date: date, center: center, str: "first notification", type: type, id: "first")
        
        date = Date().addingTimeInterval(15)
        
        setNotify(date: date, center: center, str: "second notification", type: type, id: "second")
        
        let center2 = UNUserNotificationCenter.current()
        
        center2.removePendingNotificationRequests(withIdentifiers: ["second"])
        
        
        
        
        
        //-------------------------
        
        
        //convert startTime/endTime to formattedDate
        let time = "15:30"
        let formattedDate = timeConverter(date: date, time: time)
        print(formattedDate)
        
        //-------------------------
        
        
        //get class days list from startDate to endDate
        let calendar = Calendar.current
        let today = Date()
        let end = calendar.date(byAdding: .day, value: 10, to: today)!
        let startTime = "08:00"
        
        let resultList = getWeekdayList(startDate: today, endDate: end, weekdays: "MW", startTime: startTime)
        
        print("result dates = \(resultList)")
        
    }


}

