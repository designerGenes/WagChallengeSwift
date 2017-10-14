//
//  UIColor+Design.swift
//
//  Created by Jaden Nation on 5/1/17.
//  Copyright © 2017 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit

enum DesignColor: String {
	
    case bronze = "#F2895B"
    case silver = "#EEEEEE"
    case gold = "#FFBC42"    
	case gray_0 = "#232323"
	case gray_1 = "#303030"
	case gray_2 = "#595959"

}

extension UIColor {
	class func named(_ color: DesignColor) -> UIColor {
		return UIColor(hexString: color.rawValue)
	}
}
