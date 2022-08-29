//
//  ViewController.swift
//  Reminder App
//
//  Created by Rustem Manafov on 01.08.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {return}
        
        vc.title = "New Reminder"
        vc.completion = {(title, body, date) in
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                
                let newReminder = Reminder(title: title, body: body, date: date, identifier: "id_\(title)")
                self.reminders.append(newReminder)
                self.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Wrong")
                    }
                })
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func refleshButton(_ sender: Any) {
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let row = reminders[indexPath.row]
        cell.textLabel?.text = row.title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd, MMM, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: row.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            self.reminders.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            let reminder = self.reminders[indexPath.row]
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
                success, error in
                
                if success {
                    
                    self.scheduleTest(title: reminder.title, body: reminder.body)
                } else if error != nil {
                    print(error?.localizedDescription ?? "error")
                }
            })
            completionHandler(true)
        }
        
        doneAction.image = UIImage(systemName: "checkmark")
        doneAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func scheduleTest(title: String, body: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body
        
        let targetDate = Date().addingTimeInterval(5)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Wrong")
            }
        })
    }
}
struct Reminder {
    var title: String
    var body: String
    var date: Date
    let identifier: String
}
