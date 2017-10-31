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

extension UIColor {
    
    class func coolGreyTwo() -> UIColor { return UIColor(netHex:0xb0b4b8) }
    class func greyishBrown() -> UIColor { return UIColor(netHex: 0x4a4a4a) }
    class func slateGrey() -> UIColor { return UIColor(netHex:0x646b6f) }
    class func whiteFour() -> UIColor { return UIColor(netHex: 0xfbfbfb)}
    class func loadingGrey() -> UIColor { return UIColor(netHex: 0xf2f2f4) }
    class func pinkishGrey() -> UIColor { return UIColor(netHex: 0xCECECE) }
    class func oceanBlue() -> UIColor { return UIColor(netHex: 0x0072B2) }
    class func darkMint() -> UIColor { return UIColor(netHex: 0x5bc75d) }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(redInt: red, greenInt: green, blueInt: blue, alphaInt: 255)
    }

    convenience init(redInt red: Int, greenInt green: Int, blueInt blue: Int, alphaInt alpha: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 255, "Invalid alpha component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff,
                  green:(netHex >> 8) & 0xff,
                  blue:netHex & 0xff)
    }

    convenience init(netHex: Int, alpha: Int) {
        self.init(redInt: (netHex >> 16) & 0xff,
                  greenInt: (netHex >> 8) & 0xff,
                  blueInt: netHex & 0xff,
                  alphaInt: alpha & 0xff)
    }
    
    convenience init(hexInString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexInString)
        
        if hexInString.hasPrefix("#") {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        }
        
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hexInt & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
