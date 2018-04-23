//
//  NoteTableViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/12/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import  CoreData

protocol NotesViewControllerDelegate: NSObjectProtocol {
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
}

class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, NotesViewControllerDelegate {
   
    var fetchedResultController : NSFetchedResultsController<Note>!
    
    weak var delegate: NotesViewControllerDelegate?
    var defaultNotebook : Notebook?

    override func viewDidLoad() {
        super.viewDidLoad()
        let addNote = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNoteInDefault))
        let addNotebook = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addNewNotebookModal))
        navigationItem.rightBarButtonItems = [addNote, addNotebook]
        loadData()
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDefaultNotebook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("INFO", fetchedResultController.sections!.count)
        return fetchedResultController.sections!.count
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let note = fetchedResultController.object(at: IndexPath(row: 0, section: section)) // obtiene el primer objeto de la seccion.
        
        let itsSectionName = note.notebook?.name
        
        return itsSectionName
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print("ROWS IN SECTION ", section, fetchedResultController.sections![section].numberOfObjects)
        return fetchedResultController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = "\(fetchedResultController.object(at: indexPath).title) \(fetchedResultController.object(at: indexPath).notebook?.name)"
        return cell!
    }
    
    func pushNoteView(_ note: Note) {
        let noteViewController = NoteViewByCodeController()
        noteViewController.note = note
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let note = fetchedResultController.object(at: indexPath)
       delegate?.noteTableViewController(self , didSelectNote: note)
    }
    
    @objc func addNewNotebookModal() {
        let notebookViewController = NotebookTableTableViewController()
        //notebookViewController.modalPresentationStyle = .overCurrentContext
        notebookViewController.modalTransitionStyle = .crossDissolve
        //present(notebookViewController, animated: true, completion: nil)
        navigationController?.pushViewController(notebookViewController, animated: true)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.reloadData();
    }
    
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
    {
        pushNoteView(note)
    }

}
// MARK: - DAO
extension NoteTableViewController {
    
    // MARK: Creacion de notes, en un hilo de background
    @objc func addNewNoteInDefault() {
        
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: privateMOC) as! Note
            
            let dict = ["main_title":"Nueva nota KVC", "createdAtTi" : Date().timeIntervalSince1970] as [String: Any]
            note.title = "Nueva nota"
            
            if var privateNotebook = self.defaultNotebook {
                 privateNotebook = privateMOC.object(with: privateNotebook.objectID) as! Notebook
                 note.notebook = privateNotebook
            }
           
            //note.createdAtTi = Date().timeIntervalSince1970
            note.setValuesForKeys(dict)
            try! privateMOC.save()
        }
    }
    
    func loadData() {
        //Obtenemos el singleton del MOC
        let noteMOC = DataManager.sharedManager.persistentContainer.viewContext
        
        //Creamos el objeto del fecth
        //let fetchRequest = NSFetchRequest<Note>()
        
        //Indicamos cual es la entidad relacionada al fetch
        //fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Note", in: noteMOC)
        
        //let fetchRequest = Note.fetchNoteRequest();
        
        //Aternativa borrar lineas arriba
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        //Establecemos los ordenamientos
        let sortByNotebook = NSSortDescriptor(key: "notebook.isDefault", ascending: false )
        
        let sortByName = NSSortDescriptor(key: "notebook.name", ascending: true)
        fetchRequest.sortDescriptors = [sortByNotebook]
        
        //Establecemos filtros
        let created24h = Date().timeIntervalSince1970 - 24 * 3600
        let predicate = NSPredicate(format: "createdAtTi >= %f", created24h)
        fetchRequest.predicate = predicate
        
        // MARK: Model Controller
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: noteMOC, sectionNameKeyPath: "notebook.name", cacheName: nil)
        
        try! fetchedResultController.performFetch()
        
        fetchedResultController.delegate = self
    }
    
    func loadDefaultNotebook() {
        //obtenemos el MOC
        let viewContex = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        //objeto request
        let fetchRequest = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY_NAME)
        
        //predicados
        let predicate = NSPredicate(format: " isDefault = true")
        
        //agregar el predicado al fetch
        fetchRequest.predicate = predicate
        
        var notebookList : [Notebook]?
        
        //ejecutar la request
        do {
          notebookList = try viewContex.fetch(fetchRequest)
        } catch {
            
        }
        
        if let notebooks = notebookList {
            if notebooks.count > 0 {
                defaultNotebook = notebooks[0]
            }
        }
    
    }
}
