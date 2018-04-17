//
//  NoteTableViewController.swift
//  Everpobre
//
//  Created by Mobile Sevenminds on 4/12/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
import  CoreData

class NoteTableViewController: UITableViewController {
    
    var noteList: [Note] = []
    var observer : NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
        //Obtenemos el singleton del MOC
        let noteMOC = DataManager.sharedManager.persistentContainer.viewContext
        
        //Creamos el objeto del fecth
        //let fetchRequest = NSFetchRequest<Note>()
        
        //Indicamos cual es la entidad relacionada al fetch
        //fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Note", in: noteMOC)
        
        let fetchRequest = Note.fetchNoteRequest();
        
        //Aternativa borrar lineas arriba
        //let fetchRequest2 = NSFetchRequest<Note>(entityName: "Note")
        
        //Establecemos los ordenamientos
        let sortByDate = NSSortDescriptor(key: "createdAtTi", ascending: true)
        fetchRequest.sortDescriptors = [sortByDate]
        
        //Establecemos filtros
        let created24h = Date().timeIntervalSince1970 - 24 * 3600
        let predicate = NSPredicate(format: "createdAtTi >= %f", created24h)
        fetchRequest.predicate = predicate
        
        try! noteList = noteMOC.fetch(fetchRequest)
        
        observer = NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave, object: nil, queue: OperationQueue.main, using: { (notification) in
            self.tableView.reloadData()
        })
        
        
    }
    
    deinit {
        if let obs = observer {
            NotificationCenter.default.removeObserver(obs);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = noteList[indexPath.row].title
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteViewController = NoteViewByCodeController()
        noteViewController.note = noteList[indexPath.row];
        navigationController?.pushViewController(noteViewController, animated: true)
    }

    // MARK: Creacion de notes, en un hilo de background
    @objc func addNewNote() {
        
        let privateMOC = DataManager.sharedManager.persistentContainer.newBackgroundContext()
        privateMOC.perform {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: privateMOC) as! Note
            note.title = "Nueva nota"
            note.createdAtTi = Date().timeIntervalSince1970
            try! privateMOC.save()
            
            DispatchQueue.main.async {
                let noteView = DataManager.sharedManager.persistentContainer.viewContext.object(with: note.objectID) as! Note
                self.noteList.append(noteView)
                self.tableView.reloadData()
            }
           
        }
    }
    
    @objc func updateInfo() {
        
    }
}
