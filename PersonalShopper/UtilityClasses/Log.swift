//
//  Log.swift
//

import UIKit

/// Logger for debug

final class Debug {
    
    static var isEnabled = true
    
    static func log(_ msg: @autoclosure () -> String = "", _ file: @autoclosure () -> String = #file, _ line: @autoclosure () -> Int = #line, _ function: @autoclosure () -> String = #function) {
        if isEnabled {
            let fileName = file().components(separatedBy: "/").last ?? ""
            print("[Debug] [\(fileName):\(line())]🍀🍀🍀: \(function()) \(msg())")
        }
    }
}
