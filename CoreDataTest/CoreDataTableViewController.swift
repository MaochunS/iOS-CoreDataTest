//
//  CoreDataTableViewController.swift
//  CoreDataTest
//
//  Created by maochun on 2021/1/7.
//

import UIKit
import CoreData

class CoreDataTableViewController: UIViewController {
    
    lazy var theTableView : UITableView = {
        let tview = UITableView()
        tview.translatesAutoresizingMaskIntoConstraints = false
        
        tview.delegate = self
        tview.dataSource = self
        self.view.addSubview(tview)
        
        NSLayoutConstraint.activate([
            tview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            tview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
            
        ])
        
        
        tview.register(UITableViewCell.self, forCellReuseIdentifier: "theTestCell")
        
        return tview
        
    }()
    
    //let persistentContainer = NSPersistentContainer.init(name: "TestModel")

    
    lazy var fetchedResultsController: NSFetchedResultsController<UserAccount> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managerContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()

        load()
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.theTableView.reloadData()
    }
    
    func load(){
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        /*
        //persistant container
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }

            }
        }
        */
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {

        //get intervento
        let item = fetchedResultsController.object(at: indexPath)

        //fill the cell
        cell.textLabel?.text = item.name
       
    }
}

extension CoreDataTableViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quotes = fetchedResultsController.fetchedObjects else { return 0 }
            return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "theTestCell")

        configureCell(cell, at:indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == .delete){

            // Fetch Quote
            let quote = fetchedResultsController.object(at: indexPath)

            // Delete Quote
            quote.managedObjectContext?.delete(quote)
            
            do {
                try quote.managedObjectContext?.save()

            } catch {
                fatalError("\(error)")
            }
        }
    }

}

extension CoreDataTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.theTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.theTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.theTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                self.theTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = self.theTableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                self.theTableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                self.theTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        @unknown default:
            break
        }
    }
}
