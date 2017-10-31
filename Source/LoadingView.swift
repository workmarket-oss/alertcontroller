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

@IBDesignable
class LoadingView: DesignableView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingContainer: UIView!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var reloadButton: RoundButton!
    
    var showError: Bool = false {
        didSet {
            if showError {
                errorView.isHidden = false
                loadingContainer.isHidden = true
                activityIndicator.stopAnimating()
                backgroundColor = UIColor.loadingGrey()
            } else {
                errorView.isHidden = true
                loadingContainer.isHidden = false
                activityIndicator.startAnimating()
                backgroundColor = UIColor.white
            }
        }
    }
    
    var onReloadButtonAction: (()->())?
    
    @IBInspectable var errorMessage: String? {
        didSet {
            errorMessageLabel.text = errorMessage
        }
    }
    
    @IBAction func reloadButtonAction(_ sender: RoundButton) {
        onReloadButtonAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingContainer.backgroundColor = view.backgroundColor
    }
    
}
