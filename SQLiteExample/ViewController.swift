//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Apple Guru on 2/1/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtRankingName: UITextField!
    @IBOutlet weak var txtFieldName: UITextField!
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HeroDatabase.sqlite")
        print(fileUrl)
      if sqlite3_open(fileUrl.path, &db ) != SQLITE_OK {
           print("Error open database")
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("error creating table")
        }
        
        print("every thing is ok")
    }

    @IBAction func saveAction(_ sender: Any)
    {
        
        guard let name = txtFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines), let powerrank = txtRankingName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("field is empty")
            return
        }
        
        if name.isEmpty
        {
            print("name is empty")
            return
        }
        
        if powerrank.isEmpty {
            print("rank is empty")
            return
        }
        
        var stmt: OpaquePointer?
        let insertQuery = "INSERT INTO Heroes(name, powerrank) VALUES(?,?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK
        {
            print("Error binding query")
        }
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK
        {
            print("Error binding name")
        }
        
        if sqlite3_bind_int(stmt, 2, (powerrank as NSString).intValue) != SQLITE_OK
        {
                   print("Error binding name")
               }
        if sqlite3_step(stmt) == SQLITE_DONE
        {
            print("hero saved successfully")
        }
       
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

