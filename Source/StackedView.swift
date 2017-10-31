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

public protocol StackedViewDelegate: class {
    func stackedView(_ stackedView: StackedView, spacingForView view: UIView) -> UIEdgeInsets
}

public enum StackedViewDirection {
    case vertical, horizontal
}

public class StackedView: UIView {

    public var direction: StackedViewDirection = .vertical

    var bottomConstraint: NSLayoutConstraint?

    public weak var delegate: StackedViewDelegate?

    var vAxis: String {
        get {
            return direction == .vertical ? "V" : "H"
        }
    }

    var hAxis: String {
        get {
            return direction == .vertical ? "H" : "V"
        }
    }

     public convenience init(direction: StackedViewDirection) {
        self.init(frame: CGRect.zero)
        self.direction = direction
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func addSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let lastView = self.subviews.last
        super.addSubview(view)

        let insets = delegate?.stackedView(self, spacingForView: view) ?? UIEdgeInsets.zero

        guard let previousView = lastView else {
            let vConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "\(vAxis):|-top-[addedView]",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: ["top": direction == .vertical ? insets.top : insets.left],
                views: ["addedView": view]
            )
            self.addConstraints(vConstraints)

            let hConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "\(hAxis):|-left-[addedView]-right-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: [
                    "left": direction == .vertical ? insets.left : insets.top,
                    "right": direction == .vertical ? insets.right : insets.bottom
                ],
                views: ["addedView": view]
            )

            self.addConstraints(hConstraints)
            setupBottomConstraint(forView: view, insets: insets)
            self.layoutIfNeeded()
            return
        }

        let previousInsets = delegate?.stackedView(self, spacingForView: previousView) ?? UIEdgeInsets.zero

        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "\(vAxis):[previousView]-between-[addedView]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: ["between": direction == .vertical ? insets.top + previousInsets.bottom : insets.left + previousInsets.right],
            views: ["previousView": previousView,
                "addedView": view]
        )
        self.addConstraints(constraints)

        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "\(hAxis):|-left-[addedView]-right-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: [
                "left": direction == .vertical ? insets.left : insets.top,
                "right": direction == .vertical ? insets.right : insets.bottom
            ],
            views: ["addedView": view]
        )

        self.addConstraints(hConstraints)

        setupBottomConstraint(forView: view, insets: insets)
        self.layoutIfNeeded()
    }

    public func addSubview(view: UIView, withEqualHeight: Bool) {
        let lastView = self.subviews.last
        self.addSubview(view)

        guard let previousView = lastView else {
            return
        }

        if withEqualHeight {
            let constraint = NSLayoutConstraint(item: view,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: previousView,
                                                attribute: .height,
                                                multiplier: 1,
                                                constant: 0)
            self.addConstraint(constraint)
            self.layoutIfNeeded()
        }
    }

    private func setupBottomConstraint(forView view: UIView, insets: UIEdgeInsets) {
        if let bottomConstraint = bottomConstraint {
            self.removeConstraint(bottomConstraint)
        }

        let constant = direction == .vertical ? insets.bottom : insets.right

        let constraint = NSLayoutConstraint(
            item: self,
            attribute: direction == .vertical ? .bottom : .right,
            relatedBy: .equal,
            toItem: view,
            attribute: direction == .vertical ? .bottom : .right,
            multiplier: 1.0,
            constant: constant
        )

        self.addConstraint(constraint)
        self.bottomConstraint = constraint
    }

    public func removeSubview(_ view: UIView,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {
        guard let index = self.subviews.index(of: view), index >= 0 else {
            return
        }
        // The view to be removed is the first subview amongst many subviews
        if index == 0 && self.subviews.count > 1 {
            let nextView = self.subviews[index + 1]
            let insets = delegate?.stackedView(self, spacingForView: nextView) ?? UIEdgeInsets.zero

            let vConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "\(vAxis):|-top-[nextView]",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: ["top": direction == .vertical ? insets.top : insets.left],
                views: ["nextView": nextView]
            )
            self.addConstraints(vConstraints)
        } else if index > 0 && self.subviews.count > 1 {
            let previousView = self.subviews[index - 1]
            let previousInsets = delegate?.stackedView(self, spacingForView: previousView) ?? UIEdgeInsets.zero

            // The view to be removed is the last subview amongst many subviews
            if view === self.subviews.last {
                setupBottomConstraint(forView: previousView, insets: previousInsets)

            // The view to be removed is in the middle of the stacked view
            } else {
                let nextView = self.subviews[index + 1]
                let insets = delegate?.stackedView(self, spacingForView: nextView) ?? UIEdgeInsets.zero
                let constraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "\(vAxis):[previousView]-between-[nextView]",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: ["between": direction == .vertical ? insets.top + previousInsets.bottom : insets.left + previousInsets.right],
                    views: ["previousView": previousView,
                        "nextView": nextView]
                )
                self.addConstraints(constraints)
            }
        }

        if animated {
            UIView.animate({
                view.alpha = 0
                self.layoutIfNeeded()
            }, completion: { (finished) in
                view.removeFromSuperview()
                completion?()
            })
        } else {
            view.removeFromSuperview()
            self.layoutIfNeeded()
            completion?()
        }
    }

}
