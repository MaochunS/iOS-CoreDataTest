//
//  ViewController.swift
//  CoreDataTest
//
//  Created by maochun on 2021/1/7.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var insertBtn : UIButton={
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Insert", for: .normal)
        btn.addTarget(self, action: #selector(insertDataAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return btn
        
    }()
    
    lazy var fetchBtn : UIButton={
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Fetch", for: .normal)
        btn.addTarget(self, action: #selector(fetchDataAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant:200),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return btn
        
    }()
    
    lazy var deleteBtn : UIButton={
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.addTarget(self, action: #selector(deleteDataAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return btn
        
    }()
    
    lazy var showTableViewBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Show table view", for: .normal)
        btn.addTarget(self, action: #selector(showTableViewAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 400),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        return btn
        
    }()
    
    let app = (UIApplication.shared.delegate as! AppDelegate )

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let _ = self.insertBtn
        let _ = self.fetchBtn
        let _ = self.deleteBtn
        let _ = self.showTableViewBtn

    }

    @objc func insertDataAction(){
        DispatchQueue.global().async {
            
            let moc = self.app.persistentContainer.viewContext

            
            for i in 0 ..< 1000{
                print("insert user \(i)")
                
                guard let user = NSEntityDescription.insertNewObject(forEntityName: "UserAccount", into: moc) as? UserAccount else{
                    print("create new insert object failed")
                    break
                }
              
                user.name = "user\(i)"
                user.password = "12345678"
                user.tel = "1234-1234-\(i)"

            }
            
            do {
                try moc.save()
            } catch {
                print("error \(error)")
                
            }
        }
        
    }
    
    @objc func deleteDataAction(){
        DispatchQueue.global().async {
            
            let moc = self.app.persistentContainer.viewContext
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "UserAccount"))

            do {
                try moc.execute(batchDeleteRequest)

            } catch {
                // Error Handling
            }
        }
        
        
    }
    
    @objc func fetchDataAction(){
        DispatchQueue.global().async {
            
            let moc = self.app.persistentContainer.viewContext
            
            let request = NSFetchRequest<UserAccount>(entityName: "UserAccount")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            do {
                let results = try moc.fetch(request)

                for result in results {
                    print("\(result.id). \(result.name!) \(result.password!) \(result.tel!)")
                    
                }
            } catch {
                fatalError("\(error)")
            }
        }
        
    }
    
    @objc func showTableViewAction(){
        let vc = CoreDataTableViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

