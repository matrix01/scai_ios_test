//
//  RequestProtocol.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import UIKit

enum ApiRequest {
    case detailList

    private var baseUrl: URL? {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = scheme
        return urlComponents.url
    }

    private var completeURL: URL? {
        guard let finalUrl = baseUrl?.appendingPathComponent(endPoint),
              let urlComponents = URLComponents(url: finalUrl, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to instantiate request uel")
        }
        return urlComponents.url
    }
    private var scheme: String {
        "https"
    }
    private var host: String {
        "run.mocky.io"
    }

    var endPoint: String {
        switch self {
        case .detailList: return "v3/4e23865c-b464-4259-83a3-061aaee400ba"
        }
    }

    var userAgent: String {
        let projectName     = "scai_ios_test"
        let model           = UIDevice.current.model
        let systemVersion   = UIDevice.current.systemVersion
        let name            = UIDevice.current.name
        let scale           = UIScreen.main.scale

        return String(format: "%@ (%@; iOS %@; DeviceName/%@; Scale/%0.2f)",
                      projectName, model, systemVersion, name, scale)
    }
    var method: String {
        "GET"
    }

    var request: URLRequest? {
        guard let url = completeURL else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 20000.0
        return request
    }
}
