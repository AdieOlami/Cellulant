//
//  Util.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
//import SwiftMessages

var isIPhone = UIDevice.current.model == "iPhone"
var isIPad = UIDevice.current.model == "iPad"

struct Util {
    static func showSnack(message: String) {
        
    }
    
    static func showSnackError(message: String) {
    }
    
    static func showSnackWarning(message: String) {
    }

    static func share(_ itemToShare: Any, from controller: UIViewController) {
        let shareViewController = UIActivityViewController(activityItems: [itemToShare], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
        shareViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        controller.present(shareViewController, animated: true, completion: nil)
    }
    
    static func sendToClipBoard(_ text: String) {
        UIPasteboard.general.string = text
    }
    
    public static func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    public static func formattedDateForDetails(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
