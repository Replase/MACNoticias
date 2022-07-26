//
//  TypeErrorModel.swift
//  MACNoticias
//
//  Created by Alan Emiliano Ramirez Ayala on 25/07/22.
//

import Foundation
public enum TiposDeError{
    case email
    case emailInsert
    case emailIsInUse
    case contraDebil
    case numCuenta
    case contraInv
    case contraNoIgual
    case confirm
    case errorReg
    case faltantes
    case predeter
    
    var title: String{
        switch self {
        case .email, .numCuenta, .contraInv, .contraNoIgual, .predeter, .errorReg,.faltantes,.contraDebil,.emailInsert,.emailIsInUse:
            return "¡Error!"
        case .confirm:
            return "¡Exito!"
        }
    }
    
    var message: String{
        switch self {
        case .email:
            return "Ingresa una direccion de correo electronico valida (numcuenta@pcpuma.acatlan.unam.mx)."
        case .emailIsInUse:
            return "El correo electronico que desea registrar ya esta dado de alta."
        case .numCuenta:
            return "Numero de cuenta no valido, ingresa un numero de cuenta valido."
        case .contraInv,.contraDebil:
            return "Contraseña no valida, ingresa una contraseña valida."
        case .contraNoIgual:
            return "La contraseña no pudo ser verificada, ingresa correctamente la contraseña."
        case .confirm:
            return "¡Registro exitoso!"
        case .errorReg:
            return "Error en el registro, porfavor vuelve a interlo."
        case .faltantes,.emailInsert:
            return "Ingresa los datos faltantes."
        case .predeter:
            return "¡Ups, hubo un error, porfavor intenta mas tarde."
        }
    }
}
