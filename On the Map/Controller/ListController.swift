//
//  ListController.swift
//  On the Map
//
//  Created by Jae Paek on 11/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit

class ListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(StudentModel.students)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(StudentModel.students)
        tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        refreshLocations()
    }
    
    override func refreshLocations() {
        _ = Client.getStudentInformation(completion: { students, error in
            if let error = error {
                self.showDownloadFailure(message: error.localizedDescription)
            } else {
                StudentModel.students = students
                self.tableView.reloadData()
            }
            
        })
    }

}

extension ListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StudentModel.students.count)
        return StudentModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell")!
        
        let student = StudentModel.students[indexPath.row]
        print(student)
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let student = StudentModel.students[indexPath.row]
        let app = UIApplication.shared
        app.openURL(URL(string: student.mediaURL)!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

