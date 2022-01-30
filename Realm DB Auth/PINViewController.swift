//
//  PINViewController.swift
//  Realm DB Auth
//
//  Created by John KINAV on 1/19/22.
//

import UIKit
import RealmSwift

class PINViewController: UIViewController {
    
    private let PIN_LOGIN_SEGUE = "PINloginsegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        userIDField.text = userID
        // Do any additional setup after loading the view.
    }
    
    var userID = String()
    
    let localRealm = try! Realm()
    
    @IBOutlet weak var userIDField: UILabel!
    @IBOutlet weak var PINTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let userObjs = localRealm.objects(LocalOnlyAuth.self)
        let userToken = userIDField.text
        let userPIN = PINTextField.text
        
        let user = userObjs.where {
            $0.userToken == userToken!
        }
        if user[0].userPIN == userPIN! {
            
            try! localRealm.write {
                
               user[0].userAuthorized = true
            }
            
            performSegue(withIdentifier: PIN_LOGIN_SEGUE, sender: nil)
            
        } else {
            
            alertTheUser(title: "Error", message: "Please check your PIN Number")
        }
    }
    @IBAction func logoutButton(_ sender: Any) {
        
        
        let userObjs = localRealm.objects(LocalOnlyAuth.self)

        
        let user = userObjs.where {
            $0.userAuthorized == true
        }
        try! localRealm.write {
            
           user[0].userAuthorized = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PINViewController {
    
    
    private func alertTheUser(title:String, message:String){
 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
