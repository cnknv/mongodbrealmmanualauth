//
//  ViewController.swift
//  Realm DB Auth
//
//  Created by John KINAV on 1/18/22.
//

import UIKit
import RealmSwift

protocol UserAuthDelegate {
    func fetchUserInfo() -> String
}

class ViewController: UIViewController, UserAuthDelegate {
    func fetchUserInfo() -> String {
        let userObjs = localRealm.objects(LocalOnlyAuth.self)
        let userNameText = userName.text
        let user = userObjs.where {
            $0.userName == userNameText!
        }
        return user[0].userUID
    }
    
    
    
    var userID = String()
    
    private let LOGIN_SEGUE = "loginsegue"
    private let PIN_SEGUE = "PINSegue"
    
    let localRealm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userName.text = ""
        passwordField.text = ""
        if localRealm.isEmpty {
            userName.isEnabled = false
            passwordField.isEnabled = false
            loginUserButton.isEnabled = false
            
            
            alertTheUser(title: "Error", message: "There is no users in database please add user")
            
        } else {
            
            let userObjs = localRealm.objects(LocalOnlyAuth.self)
            
            for userOBj in userObjs {
                
                if userOBj.userAuthorized == true {
                    
                 
//                    print(userOBj.userToken)
                    self.userID = userOBj.userToken
//                    print(userID)
                    performSegue(withIdentifier: PIN_SEGUE, sender: nil)
                    
                    
                }
            }
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PIN_SEGUE{
            let VC = segue.destination as! PINViewController
            VC.userID = userID
            
        } else if segue.identifier == LOGIN_SEGUE {
            
            let VC2 = segue.destination as! ScondViewController
            VC2.userName = userID
        }
       
    }


    @IBOutlet weak var loginUserButton: UIButton!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginUser(_ sender: Any) {
        
        let userObjs = localRealm.objects(LocalOnlyAuth.self)
        let userNameText = userName.text
        let userPasswordText = passwordField.text
        
        let user = userObjs.where {
            $0.userName == userNameText!
        }
        if user[0].userPassword == userPasswordText! {
            
            try! localRealm.write {
                
               user[0].userAuthorized = true
            }
            
            performSegue(withIdentifier: LOGIN_SEGUE, sender: nil)
            
        } else {
            
            alertTheUser(title: "Error", message: "Please check your email or user name")
        }
        
      
    
        
    }
    
    
    private func alertTheUser(title:String, message:String){
 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

