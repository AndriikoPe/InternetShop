//
//  SignupViewController.swift
//  InternetShop
//
//  Created by Пермяков Андрей on 10.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()

      errorLabel.alpha = 0
    }
  
  @IBOutlet weak var firstNameTextFiled: UITextField!
  
  @IBOutlet weak var lastNameTextField: UITextField!
 
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signUpButton: UIButton!
  
  @IBOutlet weak var errorLabel: UILabel!
  
/*  // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  func validateFields() -> String? {
    if firstNameTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your first name."
    }
    if lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your last name."
    }
    if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your email."
    }
    if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please enter your password."
    }
    
    if (!HelpingFuncs.isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")) {
      return "Email address is invalid"
    }
    
    return nil
  }
  
  @IBAction func singUpButtonTapped(_ sender: Any) {
    let error = validateFields()
    
    if let errorMessage = error {
      // Invalid input in text fields, so return
      showError(errorMessage)
      return
    }
    let firstName = firstNameTextFiled.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      // Show error if error is not nil
      guard error == nil else { self.showError("Error creating user"); return }
      
      let db = Firestore.firestore()
      db.collection("users").addDocument(data: ["firstname": firstName,
                                                "lastname": lastName,
                                                "uid": result!.user.uid]) { error in
        if error != nil {
          self.showError("Couldn't save user data.")
        }
      }
      // Saving last email so next time user launches they don't have to type in the address again
      UserDefaults.standard.setValue(email, forKey: Constants.Defaults.lastSuccessfulEmail)
      self.transitionToHomeScreen()
    }
  }
  
  func showError(_ errorMessage: String) {
    errorLabel.text = errorMessage
    errorLabel.alpha = 1
  }
  
  func transitionToHomeScreen() {
    let homeVC = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? UITabBarController
    
    view.window?.rootViewController = homeVC
    view.window?.makeKeyAndVisible()
  }
}
