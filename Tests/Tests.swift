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

import XCTest
@testable import WMAlertController

extension UIViewController {
    
    // This forces the viewController to load, need it for testing.
    func preloadView() {
        _ = view
    }
    
}

class Tests: XCTestCase {
    
    var baseController: UIViewController!
    var alert: WMAlertController!
    
    override func setUp() {
        super.setUp()
        baseController = UIViewController()
        baseController.preloadView()
    }
    
    override func tearDown() {
        alert?.dismiss(animated: false, completion: nil)
        super.tearDown()
    }
    
    func testSimpleAlert() {
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        XCTAssert(alert.titleLabel?.text == "Test title")
        XCTAssert(alert.messageLabel?.text == "Test message")
        XCTAssert(alert.actions.count == 0)
        XCTAssert(alert.buttonStack.subviews.count == 0)
    }
    
    func testAlertWithOneButton() {
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: nil
            )
        )
        alert.prepareForPresentation()
        XCTAssert(alert.actions.count == 1)
        XCTAssert(alert.buttonStack.subviews.count == 1)
        XCTAssert(alert.buttonStack.subviews.first is UIButton)
        if let button = alert.buttonStack.subviews.first as? UIButton {
            XCTAssert(button.title(for: .normal) == "OK")
        } else {
            XCTFail("Expected buttonContainer subview to be a UIButton")
        }
    }
    
    func testAlertWithTwoButtons() {
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: nil
            )
        )
        alert.addAction(
            WMAlertAction(
                title: "CANCEL",
                handler: nil
            )
        )
        alert.prepareForPresentation()
        XCTAssert(alert.actions.count == 2)
        if alert.buttonStack.subviews.count == 3 {
            let button1 = alert.buttonStack.subviews[0] as? UIButton
            let button2 = alert.buttonStack.subviews[2] as? UIButton
            XCTAssert(button1?.title(for: .normal) == "OK")
            XCTAssert(button2?.title(for: .normal) == "CANCEL")
        } else {
            XCTFail("Expected 2 buttons in buttonContainer")
        }
    }
    
    func testAlertWithLightStyleAndSuccessDecoration() {
        alert = WMAlertController(title: "Test title", message: "Test message", style: .light, decoration: .success)
        alert.preloadView()
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: nil
            )
        )
        alert.prepareForPresentation()
        XCTAssert(alert.actions.count == 1)
        XCTAssert(alert.view.subviews.contains(alert.circleView))
        XCTAssert(alert.style == WMAlertStyle.light)
        XCTAssert(alert.decoration == .success)
        XCTAssert(alert.alertView.backgroundColor == UIColor.white)
        if alert.buttonStack.subviews.count == 1 {
            let button1 = alert.buttonStack.subviews[0] as? UIButton
            XCTAssert(button1?.title(for: .normal) == "OK")
        } else {
            XCTFail("Expected 1 button in buttonContainer")
        }
    }
    
    func testAlertWithCustomView() {
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        let textField = UITextField()
        alert.customView = textField
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: nil
            )
        )
        alert.prepareForPresentation()
        XCTAssert(alert.contentStack.subviews.contains(textField))
        
        let keyboardNotification = Notification(
            name: Notification.Name(rawValue: "TestKeyboardWillShowNotification"),
            object: nil,
            userInfo: [
                UIKeyboardFrameEndUserInfoKey:
                    NSValue(cgRect: CGRect(x: 0, y: 0, width: 320, height: 250))]
        )
        
        alert.keyboardWillShow(keyboardNotification)
        XCTAssert(alert.alertVerticalCenterConstraint?.constant != 0)
        
        alert.keyboardWillHide(keyboardNotification)
        XCTAssert(alert.alertVerticalCenterConstraint?.constant == 0)
    }
    
    func testAlertActionHandler() {
        let expectation = self.expectation(description: "Handler called")
        
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: { action in
                    expectation.fulfill()
                }
            )
        )
        alert.prepareForPresentation()
        if let _ = alert.buttonStack.subviews.first as? UIButton {
            alert.actions.first?.performAction()
            waitForExpectations(timeout: 5, handler: { (error) in
                XCTAssert(error == nil)
            })
        } else {
            XCTFail("Expected buttonContainer subview to be a UIButton")
        }
    }
    
    func testActionWithTitle() {
        alert = WMAlertController(title: "Test title", message: "Test message")
        alert.preloadView()
        alert.addAction(
            WMAlertAction(
                title: "OK",
                handler: nil
            )
        )
        alert.addAction(
            WMAlertAction(
                title: "Cancel",
                handler: nil
            )
        )
        alert.prepareForPresentation()
        XCTAssertNotNil(alert.actionWithTitle("OK"))
        XCTAssertNotNil(alert.actionWithTitle("Cancel"))
        XCTAssertNil(alert.actionWithTitle("Action that doesn't exist"))
    }
}
