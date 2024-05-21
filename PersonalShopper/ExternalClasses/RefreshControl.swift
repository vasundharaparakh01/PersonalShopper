//
//  RefreshControl.swift
//  appName
//
//  Created by macbook on 02/01/23.
//

import UIKit

class RefreshControl: UIRefreshControl {

    let refreshImageView = UIImageView()

    override init() {
        super.init()

        // Set the label and image view properties
        refreshImageView.image = UIImage(systemName: "arrow.clockwise")
        refreshImageView.tintColor = .gray

        // Add the label and image view as subviews of the refresh control
//        addSubview(refreshImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        refreshImageView.frame = CGRect(x: frame.size.width / 2 - 20, y: frame.size.height / 2 - 20, width: 40, height: 40)
    }

}

