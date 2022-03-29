//
//  FirebaseStorageHelper.swift
//  RoomDecoratorAR
//
//  Created by Shirayo on 29.03.2022.
//

import Foundation
import Firebase

class FirebaseStorageHelper {
    static private let cloudStorage = Storage.storage()
    
    class func asyncDownloadToFilesystem(relativePath: String, completion: @escaping(_ fileUrl: URL) -> Void) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            completion(fileUrl)
            return
        } else {
            let storageRef = cloudStorage.reference(withPath: relativePath)
            
            storageRef.write(toFile: fileUrl) { url, error in
                guard let localUrl = url else {
                    print("Firebase storage: Error downloading file with path: \(relativePath)")
                    return
                }
                completion(localUrl)
            }.resume()
        }
    }
}
