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

public struct WMAlertStyle {
    var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    var backgroundColor: UIColor = UIColor.white
    var cornerRadius: CGFloat = 5
    var titleFont: UIFont = UIFont.semiboldSystemFontOfSize(20)
    var titleTextColor: UIColor = UIColor.greyishBrown()
    var titleNumberOfLines: Int = 0
    var messageFont: UIFont = UIFont.systemFont(ofSize: 16)
    var messageTextColor: UIColor = UIColor.greyishBrown()
    var messageNumberOfLines: Int = 0
    var separatorColor: UIColor = UIColor.coolGreyTwo()
    
    var titleAttributes: [NSAttributedString.Key: Any]?
    var messageAttributes: [NSAttributedString.Key: Any]?
}

extension WMAlertStyle: Equatable {}

public func == (lhs: WMAlertStyle, rhs: WMAlertStyle) -> Bool {
    return
        lhs.overlayBackgroundColor == rhs.overlayBackgroundColor &&
            lhs.backgroundColor == rhs.backgroundColor &&
            lhs.cornerRadius == rhs.cornerRadius &&
            lhs.titleFont == rhs.titleFont &&
            lhs.titleTextColor == rhs.titleTextColor &&
            lhs.titleNumberOfLines == rhs.titleNumberOfLines &&
            lhs.messageFont == rhs.messageFont &&
            lhs.messageTextColor == rhs.messageTextColor &&
            lhs.messageNumberOfLines == rhs.messageNumberOfLines &&
            lhs.separatorColor == rhs.separatorColor
}

public extension WMAlertStyle {
    
    static var light: WMAlertStyle {
        get {
            var style = WMAlertStyle()
            style.titleAttributes = [
                NSAttributedString.Key.kern: NSNumber(value: 0.6),
                NSAttributedString.Key.font: UIFont.semiboldSystemFontOfSize(20),
                NSAttributedString.Key.foregroundColor: UIColor.greyishBrown()
            ]
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = .center
            style.messageAttributes = [
                NSAttributedString.Key.kern: NSNumber(value: 0.4),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.greyishBrown()
            ]
            return style
        }
    }
    
    static var lightEmphasized: WMAlertStyle {
        get {
            var style = WMAlertStyle()
            style.backgroundColor = UIColor(netHex: 0xF1F1F1)
            style.titleFont = UIFont.lightSystemFontOfSize(32)
            style.titleTextColor = UIColor(netHex: 0xF5A623)
            style.titleNumberOfLines = 0
            style.messageTextColor = UIColor.slateGrey()
            return style
        }
    }
    
    static var dark: WMAlertStyle {
        get {
            var style = WMAlertStyle()
            style.backgroundColor = UIColor.greyishBrown()
            style.cornerRadius = 2
            style.titleFont = UIFont.thinSystemFontOfSize(32)
            style.titleTextColor = UIColor(netHex: 0xF5A623)
            style.titleNumberOfLines = 0
            style.messageFont = UIFont.systemFont(ofSize: 18)
            style.messageTextColor = UIColor.whiteFour()
            style.messageNumberOfLines = 0
            return style
        }
    }

}

public enum WMAlertDecoration {
    case none, success
}
