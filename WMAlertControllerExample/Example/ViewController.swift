/*
 * Copyright 2017 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import WMAlertController

class ViewController: UIViewController {

    @IBAction func simpleAlertAction(_ sender: Any) {
        let alertController = WMAlertController(title: "Simple Title", message: "Simple message")
        alertController.addAction(
            WMAlertAction(title: "OK", handler: { (action) in
                NSLog("Pressed OK!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func simpleAlertLightAction(_ sender: Any) {
        let alertController = WMAlertController(title: "Simple Title", message: "Simple message", style: .light)
        alertController.addAction(
            WMAlertAction(title: "OK", handler: { (action) in
                NSLog("Pressed OK!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func simpleAlertTwoButtons(_ sender: Any) {
        let alertController = WMAlertController(title: "Cool Action", message: "Are you sure you want to complete this action?", style: .light)
        alertController.addAction(
            WMAlertAction(title: "Cancel", handler: { (action) in
                NSLog("Pressed Cancel!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        alertController.addAction(
            WMAlertAction(title: "OK", handler: { (action) in
                NSLog("Pressed OK!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func simpleAlertThreeButtons(_ sender: Any) {
        let alertController = WMAlertController(title: "Cool Action", message: "Are you sure you want to complete this action?", style: .light)
        alertController.addAction(
            WMAlertAction(title: "OK", handler: { (action) in
                NSLog("Pressed OK!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        alertController.addAction(
            WMAlertAction(title: "Cancel", handler: { (action) in
                NSLog("Pressed Cancel!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        alertController.addAction(
            WMAlertAction(title: "Maybe", handler: { (action) in
                NSLog("Pressed Maybe!")
                action.alert?.dismiss(animated: true, completion: nil)
            })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
}

