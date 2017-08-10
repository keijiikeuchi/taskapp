//
//  InputViewController.swift
//  taskapp
//
//  Created by 池内佳史 on 2017/07/31.
//  Copyright © 2017年 池内佳史. All rights reserved.
//

import UIKit
import RealmSwift   // 追加する
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categryTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task!   //追加する
    let realm = try! Realm()   //追加する
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        categryTextField.text = task.category
        
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date

    }
    
    func desmissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 追加する
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categryTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.realm.add(self.task, update: true)
            
        }
        setNotification(task: task)

        
        super.viewWillDisappear(animated)
        
    }
    
    // タスクの通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger (日付マッチ)　を作成
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成(identifierが同じだとローカル通知を上書き保存)
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK") // error が nilならローカル通知登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
        
    
    }
    
    func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}







