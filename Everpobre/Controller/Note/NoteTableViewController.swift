//
//  NoteTableViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/12/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import  CoreData

protocol NotesViewControllerDelegate {
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note: Note)
}

class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, NotesViewControllerDelegate {
   
    var fetchedResultController : NSFetchedResultsController<Note>!
    var delegate: NotesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let addNote = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote));
        let addNotebook = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addNewNotebook));
        navigationItem.rightBarButtonItem =
        
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
        let sortByDate = NSSortDescriptor(key: "createdAtTi", ascending: true)
        fetchRequest.sortDescriptors = [sortByDate]
        
        //Establecemos filtros
        let created24h = Date().timeIntervalSince1970 - 24 * 3600
        let predicate = NSPredicate(format: "createdAtTi >= %f", created24h)
        fetchRequest.predicate = predicate
        
        
        // MARK: Model Controller
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: noteMOC, sectionNameKeyPath: "notebook.name", cacheName: nil)
        
        try! fetchedResultController.performFetch()
        
        fetchedResultController.delegate = self
        
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultController.sections![section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = fetchedResultController.object(at: indexPath).title
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

    // MARK: Creacion de notes, en un hilo de background
    @objc func addNewNote() {
        
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        privateMOC.perform {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: privateMOC) as! Note
            
            let dict = ["main_title":"Nueva nota KVC", "createdAtTi" : Date().timeIntervalSince1970] as [String: Any]
            note.title = "Nueva nota"
            //note.createdAtTi = Date().timeIntervalSince1970
            note.setValuesForKeys(dict)
            try! privateMOC.save()
        }
       
       
    }
    
    
    
    @objc func addNewNotebook() {
        
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
