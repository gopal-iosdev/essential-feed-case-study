//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 4/22/24.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!

    public var message: String? {
        get { isVisible ? label.text : nil }
        set { setMessageAnimated(newValue) }
    }

    private var isVisible: Bool {
        alpha > 0
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        label.text = nil
        alpha = 0
    }

    private func setMessageAnimated(_ message: String?) {
        if let message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        label.text = message

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
    }

    @IBAction private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.label.text = nil }
            }
        )
    }
}
