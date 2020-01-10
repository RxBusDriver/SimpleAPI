//
//  CurrencyCode.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import Foundation

enum CurrencyCode: String, CaseIterable {
    case USD
    case AED
    case ARS
    case AUD
    case BGN
    case BRL
    case BSD
    case CAD
    case CHF
    case CLP
    case CNY
    case COP
    case CZK
    case DKK
    case DOP
    case EGP
    case EUR
    case FJD
    case GBP
    case GTQ
    case HKD
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case ISK
    case JPY
    case KRW
    case KZT
    case MXN
    case MYR
    case NOK
    case NZD
    case PAB
    case PEN
    case PHP
    case PKR
    case PLN
    case PYG
    case RON
    case RUB
    case SAR
    case SEK
    case SGD
    case THB
    case TRY
    case TWD
    case UAH
    case UYU
    case VND
    case ZAR
    
    static func find(_ code: String) -> CurrencyCode {
        return CurrencyCode(rawValue: code) ?? CurrencyCode.USD
    }
}

