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

extension UIView {
    @nonobjc static let defaultAnimationTiming = 0.3
    
    class func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle)
            .instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    class func animate(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: UIView.defaultAnimationTiming,
                                   animations: animations,
                                   completion: completion)
    }
    
    func isDescendantOfVisibleSubviews(_ parentView: UIView) -> Bool {
        let visibleSubviews = parentView.subviews.filter { (view) -> Bool in
            return !view.isHidden
        }
        for subview in visibleSubviews {
            if self.isDescendant(of: subview) {
                return true
            }
        }
        return false
    }
    
    func addHeightConstraint(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: .none,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: constant
        )
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    func addWidthConstraint(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: .none,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: constant
        )
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    func addBottomConstraint(constant: CGFloat = 0,
                                      forSubview view: UIView,
                                                 withPriority priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1,
            constant: constant
        )
        if let priority = priority {
            constraint.priority = priority
        }
        self.addConstraint(constraint)
        return constraint
    }
    
    func removeConstraints(forAttribute attribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        var deactivatedConstraints = [NSLayoutConstraint]()
        for constraint in constraints {
            if constraint.firstAttribute == attribute {
                constraint.isActive = false
                deactivatedConstraints.append(constraint)
            }
        }
        if let sConstraints = superview?.constraints {
            for constraint in sConstraints {
                if (constraint.firstAttribute == attribute && constraint.firstItem as? UIView == self) ||
                    (constraint.secondAttribute == attribute && constraint.secondItem as? UIView == self) {
                    constraint.isActive = false
                    deactivatedConstraints.append(constraint)
                }
            }
        }
        return deactivatedConstraints
    }
    
    var topConstraint: NSLayoutConstraint? {
        get {
            for constraint in constraints {
                if constraint.firstAttribute == .top {
                    return constraint
                }
            }
            if let sConstraints = superview?.constraints {
                for constraint in sConstraints {
                    if (constraint.firstAttribute == .top && constraint.firstItem as? UIView == self) ||
                        (constraint.secondAttribute == .top && constraint.secondItem as? UIView == self) {
                        return constraint
                    }
                }
            }
            return nil
        }
    }
    
    func constrainSubviewToSize(_ subview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-left-[subview]-right-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: ["left": insets.left, "right": insets.right],
                views: ["subview": subview]
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-top-[subview]-bottom-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: ["top": insets.top, "bottom": insets.bottom],
                views: ["subview": subview]
            )
        )
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

}
