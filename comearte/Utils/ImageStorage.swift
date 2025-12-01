import Foundation
import UIKit

/// Saves and loads images to the application's documents directory.
enum ImageStorage {
    static func save(image: UIImage, name: String) throws -> String {
        let data = image.jpegData(compressionQuality: 0.8) ?? Data()
        let url = try fileURL(for: name)
        try data.write(to: url)
        return url.lastPathComponent
    }

    static func loadImage(named name: String) -> UIImage? {
        guard let url = try? fileURL(for: name) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private static func fileURL(for name: String) throws -> URL {
        let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return directory.appendingPathComponent(name)
    }
}
