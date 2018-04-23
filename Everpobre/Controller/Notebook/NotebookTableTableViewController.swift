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
let NOTEBOOK_ENTITY_NAME = "Notebook"
typealias VoidToVoid = () -> Void

class NotebookTableTableViewController: UITableViewController {
    
    var fetchedResultController : NSFetchedResultsController<Notebook>!
    var defaultNotebookIndex : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uinib = UINib.init(nibName: "FormCell", bundle: nil)
        tableView.register(uinib, forCellReuseIdentifier: CELL_ID)
        title = NOTEBOOK_ENTITY_NAME
        
        loadData()
        loadButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotebook))
        
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    func markFormCell(_ at : IndexPath, used: Bool) {
        let cell = tableView.cellForRow(at: at)
        if used {
            cell?.backgroundColor = UIColor.blue
            self.defaultNotebookIndex = at
        } else {
            cell?.backgroundColor = UIColor.white
        }
       
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
        let dictKVC : [String: Any] = ["name" : textField.text as Any]
        updateNotebook(at: textField.tag, values: dictKVC)
    }
    
}

// MARK: - acciones en celda de Notebooks
extension NotebookTableTableViewController  {
    // MARK: - Cuando se presiona el boton de eliminado.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //No hace nada pero se requiere para que las acciones salgan.
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let useRowAction = UITableViewRowAction(style: .default, title: "Usar", handler: {action, indexPath in
            if let usedIndex = self.defaultNotebookIndex {
                self.useNotebook(at: usedIndex, used: false) {
                    DispatchQueue.main.async {
                        self.markFormCell(usedIndex, used: false)
                    }
                }
            }
            
            self.useNotebook(at: indexPath, used: true) {
                DispatchQueue.main.async {
                    self.markFormCell(indexPath, used: true)
                }
            }
            
        })
        
        useRowAction.backgroundColor = UIColor.blue
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Borrar", handler: {action, indexPath in
            self.deleteNotebook(at: indexPath) {
                DispatchQueue.main.async {
                    tableView.deleteRows(at:[indexPath], with: .left)
                    if let usedIndex = self.defaultNotebookIndex {
                        if usedIndex == indexPath { // SI BORRO EL NOTEBOOK USADO, EL INDEX DEL USADO YA ES NIL
                            self.defaultNotebookIndex = nil
                        }
                    }
                }
                
            }
        })
        return[useRowAction, deleteRowAction]
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
        
        let notebook = fetchedResultController.object(at: indexPath)
        
        let edtName = cell?.edtName
        edtName?.tag = indexPath.row
        edtName?.text = notebook.name
        cell?.edtName.delegate = self;
        print(indexPath)
        DispatchQueue.main.async {
            if notebook.isDefault {
                self.markFormCell(indexPath, used:  true)
            }
        }
        let imgUsar = cell?.imgUsar
       // imgUsar?.image = UIImage(named: "targaryenSmall")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - DAO
extension NotebookTableTableViewController {
    
    func loadData() {
        let viewContext = DataManager.sharedManager.persistentContainer.viewContext
        
        let notebookFetchReq = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY_NAME)
        
        let sortDescriptor = NSSortDescriptor(key: "createdAtTi", ascending: true)
        
        notebookFetchReq.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: notebookFetchReq, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultController.performFetch()
        
        fetchedResultController.delegate = self;
    }
    
    func deleteNotebook(at: IndexPath, whenEnd: @escaping VoidToVoid ) {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        privateMOC.perform {
            var notebook = self.fetchedResultController.object(at: at)
            notebook = privateMOC.object(with: notebook.objectID) as! Notebook
            privateMOC.delete(notebook)
            try! privateMOC.save()
            whenEnd()
        }
    }
    
    @objc func addNotebook() {
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let notebook = NSEntityDescription.insertNewObject(forEntityName: NOTEBOOK_ENTITY_NAME, into: privateMOC) as! Notebook
            notebook.name = "NEW"
            notebook.createdAtTi = Date().timeIntervalSince1970
            try! privateMOC.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func updateNotebook(at: Int, values: [String: Any]) {
        // NO SE PUEDE HACER SWIP SOBRE UNA CELDA QUE SE ESTA BORRANDO.
        let indexPath = IndexPath(row: at, section: 0)
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        privateMOC.perform {
            var notebook = self.fetchedResultController.object(at: indexPath)
            notebook = privateMOC.object(with: notebook.objectID) as! Notebook
            notebook.setValuesForKeys(values)
            try! privateMOC.save()
        }
       
    }
    
    @objc func useNotebook(at: IndexPath, used: Bool, whenEnd: @escaping VoidToVoid) {
        let viewContext = DataManager.sharedManager.persistentContainer.viewContext
        print("usado: ", used, at)
        let notebook = self.fetchedResultController.object(at: at)
        
        //notebook = viewContext.object(with: notebook.objectID) as! Notebook
        
        notebook.isDefault = used
        
        do {
           try viewContext.save()
        } catch {
            print(error)
        }
        
        whenEnd()
        
    }
    
    func unmarkMarked() {
        
        let viewContext = DataManager.sharedManager.persistentContainer.viewContext
        let batchUpdate = NSBatchUpdateRequest(entityName: NOTEBOOK_ENTITY_NAME)
        batchUpdate.predicate = NSPredicate(format: "isUsing = true")
        batchUpdate.propertiesToUpdate = [AnyHashable("isUsing"): false]
        try! viewContext.execute(batchUpdate)
 
    }
    
    
}

