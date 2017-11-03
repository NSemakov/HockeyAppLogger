// ----------------------------------------------------------------------------
//
//  UIDevice.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit
import ModernDesign
import MachO

// ----------------------------------------------------------------------------

extension UIDevice.Model
{
// MARK: - Constants

    // Iphone SE, 5, 4 and less
    public static let isIdiomPhoneNarrow: Bool = {
        return UIDevice.Model.isIdiomPhone && (UIScreen.main.bounds.size.width <= 320.0)
    }()

    public static let deviceName: String? = {
        return UIDevice.Model.rxm_deviceName()
    }()

    public static let architecture: String? = {
        return UIDevice.Model.rxm_cpuArchitecture()
    }()

// MARK: - Private Methods

    fileprivate static func rxm_deviceName() -> String? {
        return UIDevice.Model.Name[UIDevice.Model.machine]
    }

    fileprivate static func rxm_cpuArchitecture() -> String?
    {
        var result: String?

        var type: cpu_type_t = 0
        var cpusubtype: cpu_subtype_t = 0
        var size = MemoryLayout<cpu_type_t>.size

        if (sysctlbyname("hw.cputype", &type, &size, nil, 0) == 0) &&       // 0 is success
           (sysctlbyname("hw.cpusubtype", &cpusubtype, &size, nil, 0) == 0) // 0 is success
        {
            let archInfo = NXGetArchInfoFromCpuType(type, cpusubtype)
            result = String(cString: (archInfo?.pointee.name)!)
        }

        return result
    }

// MARK: - Constants

    // How to get device make and model?
    // @link https://stackoverflow.com/a/20062141/3076031
    fileprivate static let Name: [String: String] =
    [
        "i386"      : "Simulator",
        "x86_64"    : "Simulator",
        "iPod1,1"   : "iPod Touch",          // (Original)
        "iPod2,1"   : "iPod Touch",          // (Second Generation)
        "iPod3,1"   : "iPod Touch",          // (Third Generation)
        "iPod4,1"   : "iPod Touch",          // (Fourth Generation)
        "iPod5,1"   : "iPod Touch",          // (5th Generation)
        "iPod7,1"   : "iPod Touch",          // (6th Generation)
        "iPhone1,1" : "iPhone",              // (Original)
        "iPhone1,2" : "iPhone",              // (3G)
        "iPhone2,1" : "iPhone",              // (3GS)
        "iPad1,1"   : "iPad",                // (Original)
        "iPad2,1"   : "iPad 2",              //
        "iPad3,1"   : "iPad",                // (3rd Generation)
        "iPhone3,1" : "iPhone 4",            // (GSM)
        "iPhone3,3" : "iPhone 4",            // (CDMA/Verizon/Sprint)
        "iPhone4,1" : "iPhone 4S",           //
        "iPhone5,1" : "iPhone 5",            // (model A1428, AT&T/Canada)
        "iPhone5,2" : "iPhone 5",            // (model A1429, everything else)
        "iPad3,4"   : "iPad",                // (4th Generation)
        "iPad2,5"   : "iPad Mini",           // (Original)
        "iPhone5,3" : "iPhone 5c",           // (model A1456, A1532 | GSM)
        "iPhone5,4" : "iPhone 5c",           // (model A1507, A1516, A1526 (China), A1529 | Global)
        "iPhone6,1" : "iPhone 5s",           // (model A1433, A1533 | GSM)
        "iPhone6,2" : "iPhone 5s",           // (model A1457, A1518, A1528 (China), A1530 | Global)
        "iPhone7,1" : "iPhone 6 Plus",       //
        "iPhone7,2" : "iPhone 6",            //
        "iPhone8,1" : "iPhone 6S",           //
        "iPhone8,2" : "iPhone 6S Plus",      //
        "iPhone8,4" : "iPhone SE",           //
        "iPhone9,1" : "iPhone 7",            //
        "iPhone9,3" : "iPhone 7",            //
        "iPhone9,2" : "iPhone 7 Plus",       //
        "iPhone9,4" : "iPhone 7 Plus",       //
        "iPhone10,1": "iPhone 8",            // CDMA
        "iPhone10,4": "iPhone 8",            // GSM
        "iPhone10,2": "iPhone 8 Plus",       // CDMA
        "iPhone10,5": "iPhone 8 Plus",       // GSM
        "iPhone10,3": "iPhone X",            // CDMA
        "iPhone10,6": "iPhone X",            // GSM

        "iPad2,7"   : "iPad Mini",           // (1nd Generation iPad Mini)
        "iPad4,1"   : "iPad Air",            // 5th Generation iPad (iPad Air) - Wifi
        "iPad4,2"   : "iPad Air",            // 5th Generation iPad (iPad Air) - Cellular
        "iPad4,4"   : "iPad Mini",           // (2nd Generation iPad Mini - Wifi)
        "iPad4,5"   : "iPad Mini",           // (2nd Generation iPad Mini - Cellular)
        "iPad4,7"   : "iPad Mini",           // (3rd Generation iPad Mini - Wifi (model A1599))
        "iPad5,3"   : "iPad Air 2 WiFi",     // iPad Air 2 - Wifi
        "iPad5,4"   : "iPad Air 2 Cellular", // iPad Air 2 - Wifi
        "iPad6,7"   : "iPad Pro 12.9-inch",  // iPad Pro 12.9 inches - (model A1584)
        "iPad6,8"   : "iPad Pro 12.9-inch",  // iPad Pro 12.9 inches - (model A1652)
        "iPad6,3"   : "iPad Pro 9.7-inch",   // iPad Pro 9.7 inches - (model A1673)
        "iPad6,4"   : "iPad Pro 9.7-inch"    // iPad Pro 9.7 inches - (models A1674 and A1675)
    ]

}

// ----------------------------------------------------------------------------
