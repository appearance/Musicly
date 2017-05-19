//
//  RequestResults.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias JSON = [String : Any]

enum Response {
    case success(JSON), failed(Error)
}
