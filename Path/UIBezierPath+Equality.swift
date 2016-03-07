//
//  UIBezierPath+Equality.swift
//  Path
//
//  Created by Christian Otkjær on 07/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

//MARK: - Equatable

public func == (lhs: UIBezierPath, rhs:UIBezierPath) -> Bool
{
    return lhs === rhs || lhs.elements == rhs.elements
}

