//
//  TableViewController.swift
//  SQLiteExample
//
//  Created by Apple Guru on 7/1/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import SQLite3

class TableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var db: OpaquePointer?
    var dataList: [Person] = []
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate func queryData() {
        dataList.removeAll()
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
        let queryStatementString = "SELECT * FROM Heroes;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let Rank = sqlite3_column_int(queryStatement, 2)
                psns.append(Person(id: Int(id), name: name, age: Int(Rank)))
                print("Query Result:")
                print("\(id) | \(name) | \(Rank)")
                let data = Person(id: Int(id), name: name, age: Int(Rank))
                dataList.append(data)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        tblView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        queryData()
        
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "addPlayerController") as? ViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.isEmpty{
            return 0
        } else {
        return dataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        cell?.txtName.text = dataList[indexPath.row].name
        cell?.txtRank.text = "\(dataList[indexPath.row].age)"
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //self.tblView.deleteRows(at: [indexPath], with: .automatic)
            dataList.remove(at: indexPath.row)
            self.deleteByID(id: indexPath.row)
            self.tblView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    func deleteByID(id:Int) {
        
          let createTableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)"
          
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("error creating table")
        }
               let deleteStatementStirng = "DELETE FROM Heroes;"
               var deleteStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                   sqlite3_bind_int(deleteStatement, 1, Int32(id))
                   if sqlite3_step(deleteStatement) == SQLITE_DONE {
                       print("Successfully deleted row.")
                   } else {
                       print("Could not delete row.")
                   }
               } else {
                   print("DELETE statement could not be prepared")
               }
        DispatchQueue.main.async {
          
            for i in 0...self.dataList.count-1 {
        var stmt: OpaquePointer?
              let insertQuery = "INSERT INTO Heroes(name, powerrank) VALUES(?,?)"
                if sqlite3_prepare(self.db, insertQuery, -1, &stmt, nil) != SQLITE_OK
              {
                  print("Error binding query")
              }
                if sqlite3_bind_text(stmt, 1, self.dataList[i].name, -1, nil) != SQLITE_OK
              {
                  print("Error binding name")
              }
              
                if sqlite3_bind_int(stmt, 2, ("\(self.dataList[i].age)" as NSString).intValue) != SQLITE_OK
              {
                         print("Error binding name")
                     }
              if sqlite3_step(stmt) == SQLITE_DONE
              {
                  print("hero saved successfully")
              }
        }
        }
             
               sqlite3_finalize(deleteStatement)
           }
}


