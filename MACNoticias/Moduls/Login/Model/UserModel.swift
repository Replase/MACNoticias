//
//  UserModel.swift
//  MACNoticias
//
//  Created by Alan Emiliano Ramirez Ayala on 25/07/22.
//

import Foundation
import UIKit
public class UserMac{
    var email: String = ""
    var password: String = ""
    var passwordConf: String = ""
    var numCuenta: Int = 0
    private var baseEmail: String = "pcpuma.acatlan.unam.mx"
    
    init(numeroDeCuenta: String,eMail: String, contraseña: String, contraseñaConf: String){
        self.numCuenta = Int(numeroDeCuenta)!
        self.email = eMail
        self.password = contraseña
        self.passwordConf = contraseñaConf
    }
    public static func VerificacionDeDatos(numCuenta: String,email: String, passwordConf: String, password: String)->Bool{
        if !numCuenta.isEmpty, !email.isEmpty,!passwordConf.isEmpty, !password.isEmpty{
            return true
        }
        return false
    }
    func VerificacionDeDatos()->Bool{
        if self.numCuenta != 0, !self.email.isEmpty,!self.passwordConf.isEmpty, !self.password.isEmpty{
            return true
        }
        return false
    }
    func EnviarAlertasRequeridas() -> UIAlertController{
        var alert: UIAlertController
        let value = VerificarDatos()
        switch value{
            case 1,6:
            alert = SendAlertRegister(typeError: .email)
            case 2:
            alert = SendAlertRegister(typeError: .numCuenta)
            case 3:
            alert = SendAlertRegister(typeError: .contraInv)
            case 4:
            alert = SendAlertRegister(typeError: .contraNoIgual)
            case 5:
            alert = SendAlertRegister(typeError: .confirm)
            default:
            alert = SendAlertRegister(typeError: .predeter)
        }
        return alert
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
    
    func VerificarDatos()->Int{
        let emailData = email.split(separator: "@")
        if !email.contains("@"){
            return 6
        }else if emailData[1] != baseEmail{
            return 1 // El email no es de pcpuma
        }else if Int(emailData[0]) != numCuenta {
            return 2 // El numero de cuenta no concuerda con el email
        }else if !verificarContraseña(password: password){
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
    
    public static func SendAlertRegister(typeError: TiposDeError)->UIAlertController{
        let alertController = UIAlertController(title: typeError.title, message: typeError.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        return alertController
    }
    
    func SendAlertRegister(typeError: TiposDeError)->UIAlertController{
        let alertController = UIAlertController(title: typeError.title, message: typeError.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        return alertController
    }
}
