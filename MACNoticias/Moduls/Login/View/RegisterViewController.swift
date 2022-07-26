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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearInputFields()

        // Do any additional setup after loading the view.
    }

    @IBAction func GetBackLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func GetRegister(_ sender: Any) {
        if !UserMac.VerificacionDeDatos(numCuenta: numeroDeCuenta.text ?? "", email: eMail.text ?? "", passwordConf: contraseña.text ?? "", password: contraseñaConf.text ?? ""){
            self.present(SendAlert(title: "¡Error!", message: "Inserta los datos solicitados."), animated: true, completion: nil)
            return
        }else if !switchLegal.isOn{
            self.present(SendAlert(title: "¡Error!", message: "Acepta los terminos y condiciones."), animated: true, completion: nil)
            return
        }
        var alert: UIAlertController
        let user: UserMac = UserMac(numeroDeCuenta: numeroDeCuenta.text ?? "", eMail: eMail.text ?? "", contraseña: contraseña.text ?? "", contraseñaConf: contraseñaConf.text ?? "")
        if user.VerificacionDeDatos(){
            alert = user.EnviarAlertasRequeridas()
            switch user.VerificarDatos(){
                case 1,2,3,4,6:
                    self.present(alert, animated: true, completion: nil)
                    return
                default:
                Auth.auth().createUser(withEmail: user.email, password: user.password){
                        (result, error) in
                    if result == result, error == nil {
                            self.present(alert, animated: true, completion: nil)
                            self.clearInputFields()
                        } else {
                            if let errorCode = AuthErrorCode.Code(rawValue: error!._code){
                                switch errorCode{
                                    case .accountExistsWithDifferentCredential, .credentialAlreadyInUse, .emailAlreadyInUse:
                                        self.present(UserMac.SendAlertRegister(typeError: .emailIsInUse), animated: true, completion: nil)
                                    case .missingEmail:
                                        self.present(UserMac.SendAlertRegister(typeError: .emailInsert), animated: true, completion: nil)
                                    case .weakPassword:
                                        self.present(UserMac.SendAlertRegister(typeError: .contraDebil), animated: true, completion: nil)
                                    default:
                                        self.present(UserMac.SendAlertRegister(typeError: .errorReg), animated: true, completion: nil)
                                }
                                return
                            }
                        }
                    }
            }
        }else{
            self.present(UserMac.SendAlertRegister(typeError: .faltantes), animated: true, completion: nil)
        }
    }
    
    func clearInputFields(){
        self.switchLegal.setOn(false, animated: true)
        self.contraseñaConf.text = ""
        self.contraseña.text = ""
        self.eMail.text = ""
        self.numeroDeCuenta.text = ""
    }
    
    func SendAlert(title: String, message: String)->UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        return alertController
    }
}
