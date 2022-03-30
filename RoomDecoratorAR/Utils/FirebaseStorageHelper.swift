//
//  FirebaseStorageHelper.swift
//  RoomDecoratorAR
//
//  Created by Shirayo on 29.03.2022.
//

import Foundation
import Firebase
import SwiftUI

class FirebaseStorageHelper: ObservableObject {
    static private let cloudStorage = Storage.storage()
    
    class func asyncDownloadToFilesystem(relativePath: String, completion: @escaping(_ fileUrl: URL) -> Void, loadProgress: @escaping (Double) -> ()) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            completion(fileUrl)
            return
        } else {
            let storageRef = cloudStorage.reference(withPath: relativePath)
            
            let task = storageRef.write(toFile: fileUrl) { url, error in
                guard let localUrl = url else {
                    print("Firebase storage: Error downloading file with path: \(relativePath)")
                    return
                }
                completion(localUrl)
            }
            task.observe(.progress) { snapshot in
                // Download reported progress
                let progress = Double(snapshot.progress!.completedUnitCount)
                  / Double(snapshot.progress!.totalUnitCount)
                loadProgress(progress)
              }
            task.resume()
        }
    }
}
