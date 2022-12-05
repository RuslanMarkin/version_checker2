import UIKit


enum TestError: Error {
    case foreignSymbol
}

func versionCompare(version: String, otherVersion: String) throws -> ComparisonResult {

    let versionDelimiter = "."
    
    var versionComponents = version.components(separatedBy: versionDelimiter)
    var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)

    let zeroDiff = versionComponents.count - otherVersionComponents.count
    
    let zeros = Array(repeating: "0", count: abs(zeroDiff))
    if zeroDiff > 0 {
        otherVersionComponents.append(contentsOf: zeros)
    } else {
        versionComponents.append(contentsOf: zeros)
    }
    
    for i in 0...versionComponents.count-1 {
        
        let demicalRangeV1 = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: versionComponents[i]))
        let demicalRangeV2 = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: otherVersionComponents[i]))
        if demicalRangeV1 && demicalRangeV2 {
        } else {
            throw TestError.foreignSymbol
        }

        if versionComponents[i] == "" {
            versionComponents[i] = "0"
        }
    }
    for i in 0...otherVersionComponents.count-1 {

        if otherVersionComponents[i] == "" {
            otherVersionComponents[i] = "0"
        }
    }
    
    for i in 0...versionComponents.count-1 {
        
        if versionComponents[i] != "0" {
            versionComponents[i] = versionComponents[i].replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
        if otherVersionComponents[i] != "0" {
            otherVersionComponents[i] = otherVersionComponents[i].replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
        
        let dif = versionComponents[i].count - otherVersionComponents[i].count
        dif
        if dif == 0 {
            if versionComponents[i] == otherVersionComponents[i]{
                if i == versionComponents.count-1 {
                    return versionComponents[i].compare(otherVersionComponents[i], options: .numeric)
                }
            } else
            if versionComponents[i] > otherVersionComponents[i] {
                return versionComponents[i].compare(otherVersionComponents[i], options: .numeric)

            } else {
                return versionComponents[i].compare(otherVersionComponents[i], options: .numeric)
            }
        } else {

            if dif > 0 {
                let repeatDif = String(repeating: "0", count: dif)
                otherVersionComponents[i] = otherVersionComponents[i] + repeatDif
                
                if versionComponents[i].compare(otherVersionComponents[i], options: .numeric) != .orderedSame {
                    return versionComponents[i].compare(otherVersionComponents[i], options: .numeric)
                }
            } else {
                let repeatDif = String(repeating: "0", count: -dif)
                versionComponents[i] = versionComponents[i] + repeatDif
                if versionComponents[i].compare(otherVersionComponents[i], options: .numeric) != .orderedSame {
                    return versionComponents[i].compare(otherVersionComponents[i], options: .numeric)
                }
            }
        }
    }
    return version.compare(otherVersion, options: .numeric)
}

do {
//    let test1 = try versionCompare(version: ".010.", otherVersion: "0.1")
    let test1 = try versionCompare(version: "0.01", otherVersion: ".1")
//    let test1 = try versionCompare(version: ".001", otherVersion: ".1")
//    let test1 = try versionCompare(version: "a.0", otherVersion: "0.0")
//    let test1 = try versionCompare(version: "0.10", otherVersion: ".1")
//    let test1 = try versionCompare(version: ".1", otherVersion: ".100")
//    let test1 = try versionCompare(version: "....00", otherVersion: ".0")
//    let test1 = try versionCompare(version: ".0000", otherVersion: "0.00")
//    let test1 = try versionCompare(version: ".", otherVersion: "0.0")
//    let test1 = try versionCompare(version: "..0.1", otherVersion: "0.0.0.1")
//    let test1 = try versionCompare(version: "01.234.56", otherVersion: "2.0.0")
//    let test1 = try versionCompare(version: "1.0", otherVersion: "1")
//    let test1 = try versionCompare(version: "3479023749023749023790479023749023790479023749023790470.343243443424234.3423423423423894238946892364896238946892364892368946246", otherVersion: "3479023749023749023790479023749023790479023749023790470.343243443424234.3423423423423894238946892364896238946892364892368946246")
//    let test1 = try versionCompare(version: "2.0", otherVersion: "1")
//    let test1 = try versionCompare(version: ".10.", otherVersion: "0.1.0")
    if test1 == .orderedSame {
        print("V1 = V2")
    } else if test1 == .orderedDescending {
        print("V1 > V2")
    } else {
        print("V1 < V2")
    }
} catch {
    print("Found undefined symbol in versions")
}

