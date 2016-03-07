//
//  LineCap.swift
//  Path
//
//  Created by Christian Otkjær on 04/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public enum LineCap
{
    case Butt, Round, Square
    
    var caLineCap : String
        { 
            switch self
            {
            case .Butt: return kCALineCapButt
            case .Round: return kCALineCapRound
            case .Square: return kCALineCapSquare
            }
    }
}
