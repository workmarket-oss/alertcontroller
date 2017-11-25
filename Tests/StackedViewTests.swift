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

class StackedViewTest: XCTestCase {
    
    var stackedView = StackedView()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSubviewHorizontal() {
        stackedView.direction = .horizontal
        addSubview()
    }
    
    func testAddSubviewVertical() {
        stackedView.direction = .vertical
        addSubview()
    }
    
    func testRemoveSubviewHorizontal() {
        stackedView.direction = .horizontal
        removeSubview()
    }
    
    func testRemoveSubviewVertical() {
        stackedView.direction = .vertical
        removeSubview()
    }
    
    func testInsertSubviewVertical() {
        stackedView.direction = .vertical
        insertSubview()
    }
    
    func testInsertSubviewHorizontal() {
        stackedView.direction = .horizontal
        insertSubview()
    }
    
    func addSubview() {
        let label1 = UILabel()
        label1.text = "First Label"
        stackedView.addSubview(label1)
        
        XCTAssert(stackedView.subviews.first === label1)
        XCTAssert(stackedView.subviews.last === label1)
        XCTAssert(stackedView.subviews.count == 1)
        
        let label2 = UILabel()
        label2.text = "First Label"
        stackedView.addSubview(label2)
        
        XCTAssert(stackedView.subviews.first === label1)
        XCTAssert(stackedView.subviews.last === label2)
        XCTAssert(stackedView.subviews.count == 2)
    }
    
    func insertSubview() {
        let label1 = UILabel()
        label1.text = "First Label"
        stackedView.addSubview(label1)
        
        XCTAssert(stackedView.subviews.first === label1)
        XCTAssert(stackedView.subviews.last === label1)
        XCTAssert(stackedView.subviews.count == 1)
        
        let label2 = UILabel()
        label2.text = "First Label"
        stackedView.addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "Middle Label"
        stackedView.insertSubview(label3, at: 1)
        
        XCTAssert(stackedView.subviews.first === label1)
        XCTAssert(stackedView.subviews[1] === label3)
        XCTAssert(stackedView.subviews.last === label2)
        XCTAssert(stackedView.subviews.count == 3)
    }
    
    func removeSubview() {
        let label1 = UILabel()
        label1.text = "First Label"
        stackedView.addSubview(label1)
        XCTAssert(stackedView.subviews.count == 1)
        
        stackedView.removeSubview(label1)
        XCTAssert(stackedView.subviews.count == 0)
        
        let label2 = UILabel()
        label2.text = "First Label"
        stackedView.addSubview(label1)
        stackedView.addSubview(label2)
        XCTAssert(stackedView.subviews.count == 2)
        
        stackedView.removeSubview(label1)
        XCTAssert(stackedView.subviews.count == 1)
        
        XCTAssert(stackedView.subviews.first === label2)
        XCTAssert(stackedView.subviews.last === label2)
        
        stackedView.removeSubview(label2)
        XCTAssert(stackedView.subviews.count == 0)
        
        let label3 = UILabel()
        label3.text = "First Label"
        stackedView.addSubview(label1)
        stackedView.addSubview(label2)
        stackedView.addSubview(label3)
        XCTAssert(stackedView.subviews.count == 3)
        
        stackedView.removeSubview(label3)
        XCTAssert(stackedView.subviews.count == 2)
        stackedView.removeSubview(label2)
        XCTAssert(stackedView.subviews.count == 1)
        stackedView.removeSubview(label1)
        XCTAssert(stackedView.subviews.count == 0)
        
        stackedView.addSubview(label1)
        stackedView.addSubview(label2)
        stackedView.addSubview(label3)
        XCTAssert(stackedView.subviews.count == 3)
        
        stackedView.removeSubview(label2)
        XCTAssert(stackedView.subviews.count == 2)
        stackedView.removeSubview(label2)
        XCTAssert(stackedView.subviews.count == 2)
        XCTAssert(stackedView.subviews.first === label1)
        XCTAssert(stackedView.subviews.last === label3)
    }
    
}

