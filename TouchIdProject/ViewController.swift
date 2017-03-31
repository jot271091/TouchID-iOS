//
//  ViewController.swift
//  TouchIdProject
//
//  Created by Apple Store on 30/03/17.
//  Copyright © 2017 Apple Store. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickTest(_ sender: Any) {
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            //TouchID can be used
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Acesso necessita de autorização", reply: {
                (success, error) in DispatchQueue.main.async {
                    if error != nil {
                        switch error!._code {
                            
                        case LAError.Code.systemCancel.rawValue:
                            self.alert("Sessão cancelada", err: error?.localizedDescription)
                            
                        case LAError.Code.userCancel.rawValue:
                            self.alert("Por favor, tente novamente", err: error?.localizedDescription)
                            
                        case LAError.Code.userFallback.rawValue:
                            self.alert("Autenticação", err: "Opção de senha escolhida")
                            // Custom code to obtain password here
                            
                        default:
                            self.alert("Falha de autenticação", err: error?.localizedDescription)
                        }
                        
                    } else {
                        self.alert("Autenticação feita com sucesso", err: "Agora você tem acesso")
                    }
                }
            })
        }else{
            switch error!.code {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                alert("TouchID is not enrolled", err: error?.localizedDescription)
            case LAError.Code.passcodeNotSet.rawValue:
                alert("Password not set", err: error?.localizedDescription)
            default:
                alert("TouchID not available", err: error?.localizedDescription)
            }
        }
    }
    
    func alert(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}

