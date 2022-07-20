//
//  LoginViewController.swift
//  MACNoticias
//
//  Created by Alan Emiliano Ramirez Ayala on 19/07/22.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var ingresaEmail: UITextField!
    @IBOutlet weak var ingresaContraseña: UITextField!
    @IBOutlet weak var iniciarSesion: UIButton!
    @IBOutlet weak var olvidasteTuCont: UIButton!
    @IBOutlet weak var registrar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func GetLogin(_ sender: Any) {
        if let email = ingresaEmail.text, let password = ingresaContraseña.text{
                Auth.auth().signIn(withEmail: email, password: password){
                    (result, error) in
                    if let result = result, error == nil {
                        self.navigationController?.pushViewController(MainViewController(email: result.user.email!, provider: .basic), animated: true)
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al registrar el usuario.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            
            
        }
    }
    
}
