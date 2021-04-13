//
//  LoginViewController.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      errorLabel.alpha = 0
    }
    
  override func viewWillAppear(_ animated: Bool) {
    let email = UserDefaults.standard.value(forKey: Constants.Defaults.lastSuccessfulEmail)
    if let validEmail = email as? String {
      loginTextField.text = validEmail
    }
  }

  @IBOutlet weak var loginTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  func validateFields() -> String? {
    if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your email."
    }
    if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your password."
    }
    
    if (!HelpingFuncs.isValidEmail(loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")) {
      return "Email address is invalid"
    }
    return nil
  }
  
  @IBAction func loginTapped(_ sender: Any) {
    let email = loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      guard error == nil else {
        self.errorLabel.text = error!.localizedDescription
        self.errorLabel.alpha = 1
        return
      }
      // Saving last email so next time user launches they don't have to type in the address again
      UserDefaults.standard.setValue(email, forKey: Constants.Defaults.lastSuccessfulEmail)
      let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? UITabBarController
      
      self.view.window?.rootViewController = homeVC
      self.view.window?.makeKeyAndVisible()
    }
  }

   @IBOutlet weak var errorLabel: UILabel!
  /*
   // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
