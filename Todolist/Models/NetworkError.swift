//
//  NetworkError.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//


enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
