

import UIKit

protocol Cell: class {

    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
       
        return "\(self)"
    }
}

