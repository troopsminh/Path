//
//  LineJoin.swift
//  Path
//
//  Created by Christian Otkjær on 04/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public enum LineJoin
{
    case Miter(CGFloat), Round, Bevel
    
    var caLineJoin : String
        {
            switch self
            {
            case .Miter(_): return kCALineJoinMiter
            case .Round: return kCALineJoinRound
            case .Bevel: return kCALineJoinBevel
            }
    }
}