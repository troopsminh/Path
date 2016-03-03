//
//  UIBezierPath+Text.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

public extension UIBezierPath
{
    convenience init(attributedString: NSAttributedString)
    {
        self.init(CGPath: CGPathCreateSingleLineStringWithAttributedString(attributedString))
    }
    
    convenience init(string: String, withFont font: UIFont)
    {
        self.init(attributedString: NSAttributedString(string: string, attributes: [NSFontAttributeName : font]))
    }
}
