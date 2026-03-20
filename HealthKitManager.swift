//
//  HealthKitManager.swift
//  PersonalHealthTracker
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var heartRate: Double?
    @Published var bloodPressureSystolic: Double?
    @Published var bloodPressureDiastolic: Double?
    @Published var bloodGlucose: Double?
    @Published var stepsCount: Double = 0.0
    @Published var sleepDurationHours: Double?
    
    // Define the data types we want to read
    private let typesToRead: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
        HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
        HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    ]
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            print("HealthKit Authorization finished. Success: \(success), Error: \(String(describing: error))")
            DispatchQueue.main.async {
                self.isAuthorized = success
                completion(success)
                if success {
                    self.fetchAllData()
                }
            }
        }
    }
    
    func fetchAllData() {
        fetchLatestHeartRate()
        fetchLatestBloodPressure()
        fetchLatestBloodGlucose()
        fetchStepsForToday()
        fetchSleepForLastNight()
    }
    
    // MARK: - Heart Rate
    private func fetchLatestHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let unit = HKUnit(from: "count/min")
            let value = sample.quantity.doubleValue(for: unit)
            DispatchQueue.main.async {
                self.heartRate = value
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: - Blood Pressure
    private func fetchLatestBloodPressure() {
        guard let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic),
              let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic),
              let correlationType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: correlationType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let correlation = samples?.first as? HKCorrelation else { return }
            
            if let systolicSample = correlation.objects(for: systolicType).first as? HKQuantitySample,
               let diastolicSample = correlation.objects(for: diastolicType).first as? HKQuantitySample {
                let unit = HKUnit.millimeterOfMercury()
                DispatchQueue.main.async {
                    self.bloodPressureSystolic = systolicSample.quantity.doubleValue(for: unit)
                    self.bloodPressureDiastolic = diastolicSample.quantity.doubleValue(for: unit)
                }
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: - Blood Glucose
    private func fetchLatestBloodGlucose() {
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else { return }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: bloodGlucoseType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let unit = HKUnit(from: "mg/dL")
            let value = sample.quantity.doubleValue(for: unit)
            DispatchQueue.main.async {
                self.bloodGlucose = value
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: - Steps
    private func fetchStepsForToday() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.stepsCount = sum.doubleValue(for: HKUnit.count())
            }
        }
        healthStore.execute(query)
    }
    
    // MARK: - Sleep
    private func fetchSleepForLastNight() {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        
        // Let's look at sleep from yesterday 6 PM to today 12 PM
        let calendar = Calendar.current
        let now = Date()
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else { return }
        
        let start = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: yesterday)!
        let end = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let samples = samples as? [HKCategorySample] else { return }
            
            // Sum only "asleep" samples
            var totalSleepSeconds: TimeInterval = 0
            for sample in samples {
                // In iOS 16+, sleep phases (core, deep, rem) are represented.
                // For simplicity, we sum anything that is not inBed/awake.
                if sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue {
                    totalSleepSeconds += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }
            
            DispatchQueue.main.async {
                self.sleepDurationHours = totalSleepSeconds / 3600.0
            }
        }
        healthStore.execute(query)
    }
}
