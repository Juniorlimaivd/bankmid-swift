//
//  LoginViewController.swift
//  bankmidtest
//
//  Created by Junior Lima on 20/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ditTappedToLogin(_ sender: Any) {
        if accountTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Por favor preencha o usuário e senha antes de logar.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        let proxy = BankProxy(username: accountTextField.text!, password: passwordTextField.text!)
        let balance = proxy.getBalance(accountTextField.text!)
        
        if balance == 0.0 {
            let alert = UIAlertController(title: "Error", message: "Credenciais inválidas.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            self.accountTextField.text = ""
            self.passwordTextField.text = ""
            
            return
        }
        
        performSegue(withIdentifier: "MainSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ViewController
        dest.username = self.accountTextField.text!
        dest.password = self.passwordTextField.text!
    }
}
