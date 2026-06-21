import Foundation
import Combine
import CoreMotion

class MotionManager: ObservableObject {
    
    static let shared  = MotionManager()
    
    @Published var accelarationData: (x: Double, y: Double, z: Double) = (0, 0, 0)
    @Published var gyroscopeData: (x: Double, y: Double, z: Double) = (0, 0, 0)
    @Published var currentActivity: ActivityType = .unknown
    
    @Published var errorMessage: String?
    
    @Published var shakedDetected: Bool = false
    
    private let motionManager = CMMotionManager()
    private let activityManager = CMMotionActivityManager()
    
    private let updateInterval: TimeInterval = 0.1 // 10hz
    
    private let shakeThreshold: Double = 2.5
    
    // Debounce Variables (time based debounce)
    private var lastShakeTime: Date = .distantPast // 1/1/1999T00:00:00.000
    private var shakeDebounceInterval: TimeInterval = 1.0 // To prevent multiple shake triggers
    
    
    // Check if all sensors needed for this app are available
    //
    var isNeccesarySensoringAvailable: Bool {
        motionManager.isAccelerometerActive &&
        motionManager.isGyroActive &&
        CMMotionActivityManager.isActivityAvailable()
    }
    
    private init() {
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval
    }
    
    private func detectShake(_ acceleration: CMAcceleration) {
        let magnitude = sqrt(
            pow(acceleration.x, 2) +
            pow(acceleration.y, 2) +
            pow(acceleration.z, 2)
        )
        
        let now = Date()
        if magnitude > shakeThreshold && now.timeIntervalSince(lastShakeTime) > shakeDebounceInterval {
            lastShakeTime = now
            
            DispatchQueue.main.async {
                self.shakedDetected = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.shakedDetected = false
                }
            }
        }
    }
    
    private func startAccelerometer() {
        guard isNeccesarySensoringAvailable else {
            errorMessage = "Accelerometer not Available"
            return
        }
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
                    
            self.accelarationData = (
                x: data.acceleration.x,
                y: data.acceleration.y,
                z: data.acceleration.z,
            )
            
            // detect shake gesture
        }
    }
    
    private func startGyroscope() {
        guard isNeccesarySensoringAvailable else {
            // Gyroscope might not be available on all devices
            return
        }
        
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else {
                return
            }
            
            self.gyroscopeData = (
                x: data.rotationRate.x,
                y: data.rotationRate.y,
                z: data.rotationRate.z
            )
        }
    }
    
    private func startActivityUpdates() {
        guard isNeccesarySensoringAvailable else { return }
        
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self = self, let activity = activity  else { return }
            
            self.currentActivity = ActivityType.from(activity: activity)
        }
    }
}

enum ActivityType: String {
    case stationary = "Stationary"
    case walking = "Walking"
    case running = "Running"
    case cycling = "Cycling"
    case automotive = "Automotive"
    case unknown = "Uknown"
    
    static func from(activity: CMMotionActivity) -> ActivityType {
        if activity.confidence == .low {
            return .unknown
        }
        
        if activity.running {
            return running
        } else if activity.cycling {
            return .cycling
        } else if activity.walking {
            return .walking
        } else if activity.stationary {
            return .stationary
        } else if activity.automotive {
            return .automotive
        } else {
            return .unknown
        }
    }
}
