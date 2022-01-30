//
//  CreateUserViewController.swift
//  Realm DB Auth
//
//  Created by John KINAV on 1/18/22.
//

import UIKit
import RealmSwift

class CreateUserViewController: UIViewController {
    
    let localRealm = try! Realm()
    private let LOGIN_SEGUE = "loginsegue"

    override func viewDidLoad() {
        super.viewDidLoad()
      
        print("User Realm User file location: \(localRealm.configuration.fileURL!.path)")
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func createUser(_ sender: Any) {
        createUser(withUserName: userNameField.text! , withPassword: passwordField.text!)
    }
    func createUser(withUserName:String, withPassword:String){
        
        let userName = userNameField.text
        let userPassword = passwordField.text
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)! {
            
            self.alertTheUser(title: "Problem with authentication", message: "Please enter your user name and password")
        } else {
            
            let userDetailsUID = createUserDetails().UID
            let userDetailsToken = createUserDetails().Token
            let authUser = LocalOnlyAuth(userAuthorized: false, userName: withUserName, userPassword: withPassword, userToken: userDetailsUID, userUID: userDetailsToken, userPIN: "0000")
            try! localRealm.write {
                localRealm.add(authUser)
            }
            
            self.alertTheUser(title: "Succesfull", message: "your user has been created now")
            
            userNameField.text = ""
            passwordField.text = ""
            
        }
        
     
        
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    func createUserDetails() -> (UID:String, Token:String) {
        
        let newUID = String(random(digits: 7))
        let Token = String(random(digits: 12))
        
        return (newUID, Token )
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





class LocalOnlyAuth: Object {
    
//    This class is the user object in db
    
    @Persisted var userAuthorized: Bool = false
    @Persisted var userName: String
    @Persisted var userPassword: String
    @Persisted var userToken: String
    @Persisted var userUID: String
    @Persisted var userPIN: String
    
    convenience init(userAuthorized: Bool, userName:String, userPassword:String, userToken: String, userUID: String, userPIN: String ) {
        self.init()
        self.userAuthorized = userAuthorized
        self.userName = userName
        self.userPassword = userPassword
        self.userToken = userToken
        self.userUID = userUID
        self.userPIN = userPIN
    }
}
