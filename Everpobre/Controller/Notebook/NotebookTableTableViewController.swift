//
//  NotebookTableTableViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/20/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import CoreData
let CELL_ID = "notebookCellReuse"
let ENTITY_NAME = "Notebook"

class NotebookTableTableViewController: UITableViewController {
    
    var fetchedResultController : NSFetchedResultsController<Notebook>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uinib = UINib.init(nibName: "FormCell", bundle: nil)
        tableView.register(uinib, forCellReuseIdentifier: CELL_ID)
       
        title = ENTITY_NAME
        
        loadData()
        loadButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - FetchedRequests delegates listeners
extension NotebookTableTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.reloadData()
    }

}

// MARK: - Modificacion del notebooks

extension NotebookTableTableViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // NO SE PUEDE HACER SWIP SOBRE UNA CELDA QUE SE ESTA BORRANDO.
        let row = textField.tag
        let indexPath = IndexPath(row: row, section: 0)
        let notebook = fetchedResultController.object(at: indexPath)
        notebook.name = textField.text
        try! notebook.managedObjectContext?.save()
    }
    
}

// MARK: - Eliminacion de Notebooks
extension NotebookTableTableViewController  {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let privateMOC = DataManager.sharedManager.persistentContainer.viewContext
        privateMOC.perform {
            let notebook = self.fetchedResultController.object(at: indexPath)
            privateMOC.delete(notebook)
            try! privateMOC.save()
            DispatchQueue.main.async {
                tableView.deleteRows(at:[indexPath], with: .left)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    
    }
    
}

// MARK: - Table view data source
extension NotebookTableTableViewController  {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? FormCell
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CELL_ID) as? FormCell
        }
        print(indexPath)
        
        let edtName = cell?.edtName
        edtName?.tag = indexPath.row
        edtName?.text = fetchedResultController.object(at: indexPath).name
        cell?.edtName.delegate = self;
        
        
        // MARK: - gestures
        //let swipeGesture =
        
        return cell!
    }
    
    
    
}

// MARK: - init loads

extension NotebookTableTableViewController {
    
    func loadData() {
        let viewContext = DataManager.sharedManager.persistentContainer.viewContext
        
        let notebookFetchReq = NSFetchRequest<Notebook>(entityName: ENTITY_NAME)
        
        let sortDescriptor = NSSortDescriptor(key: "createdAtTi", ascending: true)
        
        notebookFetchReq.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: notebookFetchReq, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultController.performFetch()
        
        fetchedResultController.delegate = self;
    }
    
    func loadButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotebook))
        
        navigationItem.rightBarButtonItems = [addButton]
        
    }
}

//MARK: - actions
extension NotebookTableTableViewController {
    @objc func addNotebook() {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let notebook = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: privateMOC) as! Notebook
            notebook.name = "NEW"
            notebook.createdAtTi = Date().timeIntervalSince1970
            try! privateMOC.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
