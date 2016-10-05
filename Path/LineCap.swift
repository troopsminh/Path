//
//  LineCap.swift
//  Path
//
//  Created by Christian Otkjær on 04/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public enum LineCap
{
    case butt, round, square
    
    var caLineCap : String
        { 
            switch self
            {
            case .butt: return kCALineCapButt
            case .round: return kCALineCapRound
            case .square: return kCALineCapSquare
            }
    }
}
