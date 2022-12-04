//
//  CoreLogUtil.swift
//  PssCore
//
//  Created by 박수성 on 2022/12/04.
//

import Foundation
import PssLogger

public func DLog(_ message: @autoclosure () -> String, filename: String = #file, line: Int = #line) {
#if DEBUG
    NSLog("<\(URL(string: filename)?.lastPathComponent ?? filename):\(line)> %@", message())
    PssLogger.message("<\(URL(string: filename)?.lastPathComponent ?? filename):\(line)> \(message())")
#endif
}
