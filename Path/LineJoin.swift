//
//  LineJoin.swift
//  Path
//
//  Created by Christian Otkjær on 04/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public enum LineJoin
{
    case miter(CGFloat), round, bevel
    
    var caLineJoin : String
        {
            switch self
            {
            case .miter(_): return kCALineJoinMiter
            case .round: return kCALineJoinRound
            case .bevel: return kCALineJoinBevel
            }
    }
}
