//
//  ScondViewController.swift
//  Realm DB Auth
//
//  Created by John KINAV on 1/18/22.
//

import UIKit
import RealmSwift

class ScondViewController: UIViewController {
    
    private let LOGOUT_SEGUE = "logoutsegue"
    let localRealm = try! Realm()
    @IBOutlet weak var userTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserID()
        userTokenLabel.text = userName
        // Do any additional setup after loading the view.
    }
    var userName = String()
    var delegate: UserAuthDelegate? = nil
    
    @IBAction func createPIN(_ sender: Any) {
        
        let userPIN = PINField.text
      
        // Check if required fields are not empty
        if (userPIN?.isEmpty)! {
            
            self.alertTheUser(title: "Error", message: "Please enter a new PIN Number")
        } else {
            let userObjs = localRealm.objects(LocalOnlyAuth.self)

            
            let user = userObjs.where {
                $0.userAuthorized == true
            }
            try! localRealm.write {
                
                user[0].userPIN = userPIN!
            }
            
            PINField.text = ""
            self.alertTheUser(title: "Succesfull", message: "your PIN has been updated now")
            
        }
    }
    @IBOutlet weak var PINField: UITextField!
    @IBAction func logout(_ sender: Any) {
        
        let userObjs = localRealm.objects(LocalOnlyAuth.self)

        
        let user = userObjs.where {
            $0.userAuthorized == true
        }
        try! localRealm.write {
            
           user[0].userAuthorized = false
        }
        
        performSegue(withIdentifier: LOGOUT_SEGUE, sender: nil)
        
    
    }
    
    func getuserID() {
        if self.delegate != nil {
            let userName = self.delegate?.fetchUserInfo()
//            print("\(userName) ")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func alertTheUser(title:String, message:String){
 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
