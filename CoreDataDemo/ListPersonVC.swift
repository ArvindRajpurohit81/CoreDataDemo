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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblPerson.tableFooterView = UIView()
        self.fetchResult()
    }
    
    func fetchResult(){
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
    }
    
    @IBAction func addClicked(_ sender: Any) {
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

extension ListPersonVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.fetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataDisplayCell", for: indexPath) as! DataDisplayCell
        
        guard let user = self.fetchController?.object(at: indexPath) else { return cell }
            
        cell.selectionStyle = .none
        if let firstName = user.firstName{
            cell.lblName.text = firstName
            if let lastName = user.lastName{
                cell.lblName.text = cell.lblName.text!  + lastName
            }
        }
        cell.lblusername.text = user.username
        cell.lblbookTitle.text = user.books.first?.title
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
            guard let user = self.fetchController?.object(at: indexPath) else { return }
            try? self.dataController.delete(user: user)
        }
    }
}
