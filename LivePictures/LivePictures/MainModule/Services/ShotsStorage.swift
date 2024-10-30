//
//  ShotsStorage.swift
//  LivePictures
//
//  Created by Tany on 30.10.2024.
//
import Foundation

class ShotsStorage {
    
    static let fileName = "LivePictures.json"
    
    func save(shots: [DrawingShot]) {
        let exportShots = shots.map{ ExportShot(units: $0.units.map{ $0.points }) }
        do {
            let data = try JSONEncoder().encode(exportShots)
            guard let string = String(data: data, encoding: .utf8) else {
                print("Handle error: encode shots")
                return
            }
            writeToFile(jsonString: string)
        } catch {
            print("Handle error: save shots")
        }
    }

    func fetch() -> [DrawingShot] {
        guard let string = readFromFile() else { return [] }
        return shotsFromJSON(json: string)
    }
    
    // MARK: - Private
    fileprivate func writeToFile(jsonString: String) {
        if let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first {
            let pathWithFilename = documentDirectory.appendingPathComponent(ShotsStorage.fileName)
            do {
                try jsonString.write(
                    to: pathWithFilename,
                    atomically: true,
                    encoding: .utf8
                )
            } catch {
                print("Handle error: writeToFile")
            }
        }
    }
    
    fileprivate func readFromFile() -> String? {
        if let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first {
            let pathWithFilename = documentDirectory.appendingPathComponent(ShotsStorage.fileName)
            do {
                return try String(contentsOf: pathWithFilename, encoding: .utf8)
            } catch {
                print("Handle error: readFromFile")
            }
        }
        return nil
    }
    
    fileprivate func shotsFromJSON(json: String) -> [DrawingShot] {
        guard let data = json.data(using: .utf8) else { return [] }
        guard let exportShot = try? JSONDecoder().decode([ExportShot].self, from: data) else { return [] }
        return exportShot.map{ DrawingShot.init(units: $0.units.map{ DrawingUnit(points: $0) } ) }
    }
}
