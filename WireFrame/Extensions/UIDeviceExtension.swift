//
//  UIDeviceExtension.swift
//  WireFrame
//
//  Created by Steven Lee on 8/27/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public var deviceIOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public var deviceScreenWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width;
        return width
    }
    public var deviceScreenHeight: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let height = screenSize.height;
        return height
    }
    
    
    
    
    public var deviceOrientationString: String {
        var orientation : String
        switch UIDevice.current.orientation{
        case .portrait:
            orientation="Portrait"
        case .portraitUpsideDown:
            orientation="Portrait Upside Down"
        case .landscapeLeft:
            orientation="Landscape Left"
        case .landscapeRight:
            orientation="Landscape Right"
        case .faceUp:
            orientation="Face Up"
        case .faceDown:
            orientation="Face Down"
        default:
            orientation="Unknown"
        }
        return orientation
    }
    
    //  Landscape Portrait
    public var isDevicePortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    public var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var isIPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    var isIPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    var screenType: ScreenType? {
        guard isIPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436.0:
            return .iPhoneX
            
        default:
            return nil
        }
    }
    
    // helper funcs
    static func isScreen35inch() -> Bool {
        return UIDevice().screenType == .iPhone4
    }
    
    func isScreen4inch() -> Bool {
        return UIDevice().screenType == .iPhone5
    }
    
    func isScreen47inch() -> Bool {
        return UIDevice().screenType == .iPhone6
    }
    
    func isScreen55inch() -> Bool {
        return UIDevice().screenType == .iPhone6Plus
    }
}
