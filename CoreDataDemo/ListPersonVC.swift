//
//  ListPersonVC.swift
//  CoreDataDemo
//
//  Created by Arvind on 18/04/20.
//  Copyright © 2020 Openapp. All rights reserved.
//

import UIKit
import CoreData


class ListPersonVC: UIViewController {

    @IBOutlet weak var tblPerson:UITableView!
    let dataController = DataController()
    var fetchController: NSFetchedResultsController<User>?
    var fetchControllerTask: NSFetchedResultsController<Task>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tblPerson.tableFooterView = UIView()
        
   self.fetchResult()
   //  self.fetchTask()
        
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    

    
    @IBAction func addClicked(_ sender: Any) {
        self.addHardTaskWithUserAndBook()
        return
        let alertController = UIAlertController(title: "New User", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let user = User(context: self.dataController.context)
            user.firstName = alertController.textFields?[0].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            user.lastName = alertController.textFields?[1].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            user.username = alertController.textFields?[2].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            try? self.dataController.insert(user: user, withBook: true)
        })
        
        alertController.addTextField { textField in
            textField.placeholder = "First name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Last name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Username"
        }
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }


}

extension ListPersonVC{
    func addHardTaskWithUserAndBook(){
        let taskobj = Task(context: self.dataController.context)
        taskobj.details = "I need to read at least half hour"
        
        let taskobj2 = Task(context: self.dataController.context)
        taskobj2.details = "I need to read for one weak on average of half hour"
        
        let bookobj = Book(context: self.dataController.context)
        bookobj.title = "Be a smart"
        
        let user = User(context: self.dataController.context)
        user.firstName = "user"
        user.lastName = "10"
        user.username = "User 10"
        
        user.addToTask([taskobj,taskobj2])
        user.addToBooks(bookobj)
        
        try? self.dataController.insertOnly(user: user)
    }
    
    private func fetchResult(){
        self.dataController.initalizeStack {
            _ = try? self.dataController.fetchUsers()
            let request = User.fetchRequest() as NSFetchRequest<User>
            request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
            let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: self.dataController.context,
                                                             sectionNameKeyPath: nil, cacheName: nil)
            
            fetchController.delegate = self
            self.fetchController = fetchController
            try? fetchController.performFetch()
        }
        
        let userarr = try? self.dataController.fetchUsers()
        
        let  bookarr = try? self.dataController.fetchBooks()
        
        debugPrint("user\(userarr?.count)")
        debugPrint("book\(bookarr?.count)")
    }
    
    private func fetchTask(){
        self.dataController.initalizeStack {
           // _ = try? self.dataController.fetchTask()
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            request.sortDescriptors = [NSSortDescriptor(key: "details", ascending: true)]
            let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: self.dataController.context,
                                                             sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchControllerTask = fetchController
            self.fetchControllerTask?.delegate = self
            try? self.fetchControllerTask?.performFetch()
        }
    }

}

extension ListPersonVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       // return self.fetchController?.fetchedObjects?.count ?? 0
         return self.fetchController?.fetchedObjects?.count ??  self.fetchControllerTask?.fetchedObjects?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataDisplayCell", for: indexPath) as! DataDisplayCell
        
        if self.fetchController?.fetchedObjects?.count ?? 00 > 0{
            cell.userModel = self.fetchController?.object(at: indexPath)
        }else  if self.fetchControllerTask?.fetchedObjects?.count ?? 0 > 0{
            cell.taskModel = self.fetchControllerTask?.object(at: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

extension ListPersonVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete: self.tblPerson.deleteRows(at: [indexPath!], with: .automatic)
        case .insert: self.tblPerson.insertRows(at: [newIndexPath!], with: .automatic)
        case .update: self.tblPerson.reloadRows(at: [indexPath!], with: .automatic)
        case .move: self.tblPerson.reloadData()
        @unknown default:
            self.tblPerson.reloadData()
        }
    }
}





class DataDisplayCell:UITableViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblbookTitle: UILabel!
    @IBOutlet weak var lblTaskDetails:UILabel!
    
    var taskModel:Task? = nil{
        didSet{
            if let firstName = taskModel?.user?.firstName{
                self.lblName.text = firstName
                if let lastName = taskModel?.user?.lastName{
                    self.lblName.text = self.lblName.text!  + lastName
                }
            }
            self.lblusername.text = taskModel?.user?.username
            self.lblbookTitle.text = taskModel?.user?.books?.first?.title
            self.lblTaskDetails.text = taskModel?.details
        }
    }
    
    var userModel:User? = nil{
        didSet{
            if let firstName = userModel?.firstName{
                self.lblName.text = firstName
                if let lastName = userModel?.lastName{
                    self.lblName.text = self.lblName.text!  + lastName
                }
            }
            self.lblusername.text = userModel?.username
            self.lblbookTitle.text = userModel?.books?.first?.title
            self.lblTaskDetails.text = userModel?.task?.first?.details
        }
    }

    
  

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureData(){
        
    }
}


extension ListPersonVC {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if self.fetchController?.fetchedObjects?.count ?? 0 > 0{
                guard let user = self.fetchController?.object(at: indexPath) else { return }
                try? self.dataController.deleteTask(task: user.task?.first ?? Task())
                try? self.dataController.delete(user: user)
            }else{
                guard let task = self.fetchControllerTask?.object(at: indexPath) else { return }
                try? self.dataController.deleteTask(task: task)
            }
        }
    }
}
