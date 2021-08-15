//
//  ViewController.swift
//  BodyWeightRecordSample3
//
//  Created by niwa  shuhei on 2021/08/14.
//

import UIKit
import RealmSwift

class Item:Object {
    @objc dynamic var dateString = ""
    @objc dynamic var title = ""
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var todoItem: Results<Item>!

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.textField.delegate = self

        do {
            let realm = try Realm()
            self.todoItem = realm.objects(Item.self)
        } catch  {
            print("error")
        }

        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label1 = cell.contentView.viewWithTag(1)as! UILabel
        let label2 = cell.contentView.viewWithTag(2)as! UILabel

        label1.text = String(todoItem[[indexPath.row][0]].dateString)
        label2.text = "\(String(todoItem[[indexPath.row][0]].title))Kg"
        return cell
    }

    //cellの値とrealmから対象のデータを削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(todoItem[indexPath.row])
            }
            tableView.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func addActionButton(_ sender: UIButton) {
        guard let title = textField.text else { return }

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = dateFormatter.string(from: date)
//        let textFieldItem: Item = Item(dateString: dateString, title: title)
//        todoItem.append(textFieldItem)
        let todoItem = Item()
        todoItem.dateString = dateString
        todoItem.title = title

        //Realm Swiftにデータを入れる
        let realm = try! Realm()

        try! realm.write {
            realm.add(todoItem)
        }
        textField.text = ""
        tableView.reloadData()

        textField.resignFirstResponder()
    }
    
}

