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

open class WMAlertController: UIViewController, StackedViewDelegate {
    
    public var backgroundView: UIView!
    var alertView: RoundView!
    public var scrollView: UIScrollView!
    public var contentStack: StackedView!
    public var buttonStackSeparator: UIView!
    public var buttonStack: StackedView!
    var buttonSeparators: [UIView]!
    var loadingView: LoadingView!
    
    public var customView: UIView?
    public var customViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    public var titleLabel: UILabel?
    public var messageLabel: UILabel?
    
    public var message: String?
    
    public var loading: Bool = false {
        didSet {
            if loading {
                alertView.bringSubview(toFront: loadingView)
                loadingView.isHidden = false
                loadingView.activityIndicator.startAnimating()
            } else {
                alertView.sendSubview(toBack: loadingView)
                loadingView.isHidden = true
                loadingView.activityIndicator.stopAnimating()
            }
        }
    }
    
    public var actions = [WMAlertAction]()
    
    var style: WMAlertStyle = WMAlertStyle.dark
    
    func setStyle(_ style: WMAlertStyle) {
        self.style = style
    }
    
    public var decoration: WMAlertDecoration = .none
    
    public init(title: String?, message: String?, style: WMAlertStyle = .dark, decoration: WMAlertDecoration = .none) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.message = message
        self.setStyle(style)
        self.decoration = decoration
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        registerForKeyboardNotification()
        self.initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        registerForKeyboardNotification()
        self.initViews()
    }
    
    func initViews() {
        backgroundView = UIView()
        alertView = RoundView()
        loadingView = LoadingView()
        scrollView = UIScrollView()
        contentStack = StackedView()
        contentStack.delegate = self
        buttonStack = StackedView(direction: .horizontal)
        buttonStack.delegate = self
        
        buttonStackSeparator = UIView()
        buttonSeparators = [UIView]()
        
        if let _ = self.title {
            titleLabel = UILabel()
            titleLabel?.textAlignment = .center
        }
        
        if let _ = self.message {
            messageLabel = UILabel()
            messageLabel?.textAlignment = .center
        }
    }
    
    open func didInitViews() {
        // used by subclasses to initialize a custom view
    }
    
    var alertVerticalCenterConstraint: NSLayoutConstraint?
    var alertVerticalMarginConstraints: [NSLayoutConstraint]?
    var scrollViewHeightConstraint: NSLayoutConstraint?
    var alertViewMargin: CGFloat = 25
    
    func layoutViews() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        self.view.constrainSubviewToSize(backgroundView)
        
        layoutAlertView()
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        alertView.addSubview(loadingView)
        alertView.constrainSubviewToSize(loadingView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(scrollView)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.clipsToBounds = false
        scrollView.addSubview(contentStack)
        scrollView.constrainSubviewToSize(contentStack)
        
        alertView.addConstraint(NSLayoutConstraint(
            item: scrollView,
            attribute: .width,
            relatedBy: .equal,
            toItem: contentStack,
            attribute: .width,
            multiplier: 1,
            constant: 0
            )
        )
        
        let scrollViewHeightConstraint = NSLayoutConstraint(
            item: scrollView,
            attribute: .height,
            relatedBy: .equal,
            toItem: contentStack,
            attribute: .height,
            multiplier: 1,
            constant: 0
        )
        self.scrollViewHeightConstraint = scrollViewHeightConstraint
        scrollView.addConstraint(scrollViewHeightConstraint)
        
        switch decoration {
        case .none:
            alertView.constrainSubviewToSize(scrollView, insets: UIEdgeInsets.zero)
        default:
            alertView.constrainSubviewToSize(
                scrollView,
                insets: UIEdgeInsets(top: circleSize / 2, left: 0, bottom: 0, right: 0)
            )
            setupCircleView()
        }
        
        setupDefaultLabels()
        
        // custom stuff
        if let customView = self.customView {
            contentStack.addSubview(customView)
        }
        
        if actions.count > 0 {
            setupButtons()
            constrainAlertViewWithButtons()
        }
        
    }
    
    fileprivate func layoutAlertView() {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.clipsToBounds = false
        view.addSubview(alertView)
        
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-margin-[alertView]-margin-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: ["margin": alertViewMargin],
                views: ["alertView": alertView]
            )
        )
        
        let centerConstraint = NSLayoutConstraint(
            item: alertView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        alertVerticalCenterConstraint = centerConstraint
        view.addConstraint(centerConstraint)
    }
    
    fileprivate func constrainAlertViewWithButtons() {
        let bottomConstraints = alertView.constraints.filter { (constraint) -> Bool in
            return constraint.secondItem === scrollView && constraint.firstAttribute == .bottom
        }
        
        for constraint in bottomConstraints {
            constraint.isActive = false
        }
        
        alertView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[scrollView]-0-[buttonStackSeparator]-0-[buttonStack]-0-|",
            options: [.alignAllLeft, .alignAllRight],
            metrics: nil, views: [
                "scrollView": scrollView,
                "buttonStackSeparator": buttonStackSeparator,
                "buttonStack": buttonStack
            ]))
    }
    
    fileprivate func setupButtons() {
        buttonStackSeparator.translatesAutoresizingMaskIntoConstraints = false
        _ = buttonStackSeparator.addHeightConstraint(constant: 0.5)
        
        alertView.addSubview(buttonStackSeparator)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(buttonStack)
        
        let direction: StackedViewDirection = actions.count > 2 ? .vertical : .horizontal
        
        buttonStack.direction = direction
        
        for action in actions {
            let button = createButton(forAction: action)
            if buttonStack.subviews.count > 0 {
                let separator = UIView()
                separator.translatesAutoresizingMaskIntoConstraints = false
                if direction == .horizontal {
                    _ = separator.addWidthConstraint(constant: 0.5)
                } else {
                    _ = separator.addHeightConstraint(constant: 0.5)
                }
                buttonSeparators.append(separator)
                buttonStack.addSubview(separator)
            }
            buttonStack.addSubview(button)
        }
        
        if actions.count == 2,
            let button1 = buttonStack.subviews.first,
            let button2 = buttonStack.subviews.last,
            buttonStack.subviews.count == 3 {
            NSLayoutConstraint.activate(
                [NSLayoutConstraint(
                    item: button1,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: button2,
                    attribute: .width,
                    multiplier: 1,
                    constant: 0)
                ]
            )
        }
    }
    
    let circleView = UIView()
    var circleSize: CGFloat = 110
    
    fileprivate func setupCircleView() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleView)
        
        view.addConstraint(NSLayoutConstraint(
            item: circleView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        )
        
        view.addConstraint(NSLayoutConstraint(
            item: circleView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: alertView,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        )

        _ = circleView.addHeightConstraint(constant: circleSize)
        _ = circleView.addWidthConstraint(constant: circleSize)
        
        let borderWidth: CGFloat = 15
        
        circleView.layer.cornerRadius = circleSize / 2
        circleView.backgroundColor = UIColor.white
        circleView.clipsToBounds = true
        circleView.layer.borderWidth = borderWidth
        circleView.layer.borderColor = UIColor.white.cgColor
        
        let iconImage = WMAlertIconStyleKit.imageOfCheckmark
        let circleIconView = UIImageView(image: iconImage.withRenderingMode(.alwaysTemplate))
        circleIconView.tintColor = UIColor.darkMint()
        circleIconView.backgroundColor = UIColor.clear
        circleIconView.layer.cornerRadius = (circleSize - borderWidth - borderWidth) / 2
        circleIconView.translatesAutoresizingMaskIntoConstraints = false
        
        circleView.addSubview(circleIconView)
        circleView.constrainSubviewToSize(
            circleIconView,
            insets: UIEdgeInsets(
                top: borderWidth,
                left: borderWidth,
                bottom: borderWidth,
                right: borderWidth
            )
        )
    }
    
    fileprivate func setupDefaultLabels() {
        if let titleLabel = titleLabel, let title = self.title {
            if let titleAttributes = style.titleAttributes {
                let attributedString = NSAttributedString(string: title, attributes: titleAttributes)
                titleLabel.attributedText = attributedString
            } else {
                titleLabel.text = title
            }
            contentStack.addSubview(titleLabel)
        }
        
        if let messageLabel = messageLabel, let message = self.message {
            if let messageAttributes = style.messageAttributes {
                let attributedString = NSAttributedString(string: message, attributes: messageAttributes)
                messageLabel.attributedText = attributedString
            } else {
                messageLabel.text = message
            }
            contentStack.addSubview(messageLabel)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.presentingViewController?.view.endEditing(true)
        layoutViews()
        applyStyle()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if alertView.frame.height > view.bounds.height - (alertViewMargin * 2) {
            scrollViewHeightConstraint?.isActive = false
            
            let marginConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-margin-[alertView]-margin-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: ["margin": alertViewMargin],
                views: ["alertView": alertView]
            )
            alertVerticalMarginConstraints = marginConstraints
            view.addConstraints(marginConstraints)
            
            view.setNeedsUpdateConstraints()
            view.layoutIfNeeded()
        }
    }
    
    func applyStyle() {
        backgroundView.backgroundColor = style.overlayBackgroundColor
        alertView.backgroundColor = style.backgroundColor
        alertView.cornerRadius = style.cornerRadius
        titleLabel?.font = style.titleFont
        titleLabel?.textColor = style.titleTextColor
        titleLabel?.numberOfLines = style.titleNumberOfLines
        messageLabel?.font = style.messageFont
        messageLabel?.textColor = style.messageTextColor
        messageLabel?.numberOfLines = style.messageNumberOfLines
        
        buttonStackSeparator.backgroundColor = style.separatorColor
        for separator in buttonSeparators {
            separator.backgroundColor = style.separatorColor
        }
    }
    
    public func addAction(_ action: WMAlertAction) {
        actions.append(action)
        action.alert = self
    }
    
    public func actionWithTitle(_ title: String) -> WMAlertAction? {
        for action in actions {
            if action.title == title {
                return action
            }
        }
        return nil
    }
    
    func prepareForPresentation() {
        layoutViews()
        applyStyle()
    }
    
    fileprivate func createButton(forAction action: WMAlertAction) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.oceanBlue(), for: UIControlState())
        button.setTitle(action.title, for: UIControlState())
        button.titleLabel?.font = UIFont.semiboldSystemFontOfSize(14)
        button.addTarget(action, action: #selector(WMAlertAction.performAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        _ = button.addHeightConstraint(constant: 44)
        button.sizeToFit()
        return button
    }
    
    // MARK: StackedViewDelegate
    
    public func stackedView(_ stackedView: StackedView, spacingForView view: UIView) -> UIEdgeInsets {
        if stackedView === contentStack {
            if view === titleLabel {
                if decoration == .none {
                    return UIEdgeInsets(top: 25, left: 27, bottom: 0, right: 27)
                } else {
                    return UIEdgeInsets(top: 5, left: 27, bottom: 0, right: 27)
                }
            } else if view === messageLabel {
                return UIEdgeInsets(top: 15, left: 27, bottom: 30, right: 27)
            } else if view === customView {
                return customViewInsets
            }
        }
        return UIEdgeInsets.zero
    }
    
    // MARK: Keyboard Stuff
    
    var isKeyboardShown: Bool = false
    var keyboardHeight: CGFloat = 0

    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name:NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    var maximumScrollViewHeightConstraint: NSLayoutConstraint?
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        if let info = notification.userInfo, let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            keyboardHeight = keyboardFrame.height
        }
        let maxHeight = view.bounds.height - keyboardHeight
        
        if let constraints = self.alertVerticalMarginConstraints {
            for constraint in constraints {
                constraint.isActive = false
            }
        }
        
        if alertView.frame.height > maxHeight {
            alertVerticalCenterConstraint?.constant = -(keyboardHeight / 2)
            scrollViewHeightConstraint?.isActive = false
            maximumScrollViewHeightConstraint = scrollView.addHeightConstraint(constant: maxHeight)
            animateLayoutChange()
        } else {
            alertVerticalCenterConstraint?.constant = -(keyboardHeight / 2)
            animateLayoutChange()
        }
        isKeyboardShown = true
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        keyboardHeight = 0
        isKeyboardShown = false
        alertVerticalCenterConstraint?.constant = 0
        maximumScrollViewHeightConstraint?.isActive = false
        scrollViewHeightConstraint?.isActive = true
        if let constraints = self.alertVerticalMarginConstraints {
            for constraint in constraints {
                constraint.isActive = true
            }
        }
        animateLayoutChange()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func animateLayoutChange() {
        self.view.setNeedsUpdateConstraints()
        UIView.animate({
            self.view.layoutIfNeeded()
        })
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override open var shouldAutorotate : Bool {
        return false
    }
    
}
