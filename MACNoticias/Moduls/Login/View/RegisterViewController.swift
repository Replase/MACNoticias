//
//  RegisterViewController.swift
//  MACNoticias
//
//  Created by Alan Emiliano Ramirez Ayala on 19/07/22.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class RegisterViewController: UIViewController {


    @IBOutlet weak var contraseñaConfLabel: UILabel!
    @IBOutlet weak var contraseñaLabel: UILabel!
    @IBOutlet weak var numeroDeCuentaLabel: UILabel!
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var contraseñaConf: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var numeroDeCuenta: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var switchLegal: UISwitch!
    @IBOutlet weak var terminosServicio: UIButton!
    @IBOutlet weak var politicasServicio: UIButton!
    @IBOutlet weak var registrarBtn: UIButton!
    
    private var email: String = ""
    private var password: String = ""
    private var passwordConf: String = ""
    private var numCuenta: Int = 0
    private var baseEmail: String = "pcpuma.acatlan.unam.mx"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func GetBackLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func GetRegister(_ sender: Any) {
        let num: String = numeroDeCuenta.text ?? ""
        self.numCuenta = Int(num)!
        self.email = eMail.text!
        self.password = contraseña.text!
        self.passwordConf = contraseñaConf.text!
        if self.numCuenta != 0, !self.email.isEmpty,!self.passwordConf.isEmpty, !self.password.isEmpty{
            let value = VerificarDatos(email: self.email, password: self.password, numCuenta: self.numCuenta)
            switch value{
                case 1:
                SendAlertRegister(typeError: .email)
                return
                case 2:
                SendAlertRegister(typeError: .numCuenta)
                return
                case 3:
                SendAlertRegister(typeError: .contraInv)
                return
                case 4:
                SendAlertRegister(typeError: .contraNoIgual)
                return
                case 5:
                SendAlertRegister(typeError: .confirm)
                default:
                SendAlertRegister(typeError: .predeter)
                return
            }
                Auth.auth().createUser(withEmail: email, password: self.password){
                    (result, error) in
                    if let result = result, error == nil {
                        self.navigationController?.pushViewController(MainViewController(email: result.user.email!, provider: .basic), animated: true)
                        
                    } else {
                        self.SendAlertRegister(typeError: .errorReg)
                    }
                }
            
            
        }
    }
    
    func VerificarDatos(email: String, password: String, numCuenta: Int)->Int{
        let emailData = email.split(separator: "@")
        if emailData[1] != baseEmail{
            return 1 // El email no es de pcpuma
        }else if Int(emailData[0]) != numCuenta {
            return 2 // El numero de cuenta no concuerda con el email
        }else if verificarContraseña(password: password){
            return 3 // La contraseña no cumple con las reglas de contraseñas seguras
        }else if password !=  self.passwordConf{
            return 4 // La contraseña no concuerda con la confirmarcontraseña
        }
        return 5
    }
    
    func verificarContraseña(password: String)-> Bool{
        let passwordprove = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}") //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        return passwordprove.evaluate(with: password)
    }
    
    func SendAlertRegister(typeError: TiposDeError){
        let alertController = UIAlertController(title: typeError.title, message: typeError.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alertController, animated: true, completion: nil)
    }

}

public enum TiposDeError{
    case email
    case numCuenta
    case contraInv
    case contraNoIgual
    case confirm
    case errorReg
    case predeter
    
    var title: String{
        switch self {
        case .email, .numCuenta, .contraInv, .contraNoIgual, .predeter, .errorReg:
            return "¡Error!"
        case .confirm:
            return "¡Exito!"
        }
    }
    
    var message: String{
        switch self {
        case .email:
            return "Ingresa una direccion de correo electronico valida (numcuenta@pcpuma.acatlan.unam.mx)."
        case .numCuenta:
            return "Numero de cuenta no valido, ingresa un numero de cuenta valido."
        case .contraInv:
            return "Contraseña no valida, ingresa una contraseña valida."
        case .contraNoIgual:
            return "La contraseña no pudo ser verificada, ingresa correctamente la contraseña."
        case .confirm:
            return "¡Registro exitoso!"
        case .errorReg:
            return "Error en el registro, porfavor vuelve a interlo."
        case .predeter:
            return "¡Ups, hubo un error, porfavor intenta mas tarde."
        }
    }
}
