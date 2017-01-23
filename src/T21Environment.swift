//
//  T21Environment.swift
//  MyApp
//
//  Created by Eloi Guzmán Cerón on 20/01/17.
//  Copyright © 2017 Worldline. All rights reserved.
//

import Foundation
import T21Notifier

public protocol T21EnvironmentNotifications : class {
    func languageUpdated( _ language: String)
}

public class T21Environment {
    
    public enum LanguageUpdate {
        case updated
        case notSupported
        case sameAsBefore
    }
    
    //MARK: Initializers
    
    public init( _ environments: Dictionary<String,Any>) {
        loadEnvironments(environments)
    }
    
    public func loadEnvironments( _ environments: Dictionary<String,Any>) {
        self.environments = environments
        if checkEnvironmentsFormat(self.environments) {
            _ = initializeAppLanguageData()
        } else {
            T21EnvironmentLogger.warning("Malformed environments.json file")
        }
    }
    
    //MARK: Observers management
    
    public func addEnvironmentObserver( _ observer: T21EnvironmentNotifications) {
        notifier.addObserver(observer: observer)
    }
    
    public func removeEnvironmentObserver( _ observer: T21EnvironmentNotifications) {
        notifier.removeObserver(observer: observer)
    }
    
    private func notifyLanguageChanged( _ language: String) {
        notifier.notify { (obs) in
            obs.languageUpdated(language)
        }
    }
    
    //MARK: App Language
    
    public func setAppLanguage(_ language: String) -> LanguageUpdate {
        
        if isLanguageSupported(language) {
            if self.storedAppLanguage != nil && self.storedAppLanguage!.compare(language, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == ComparisonResult.orderedSame {
                return LanguageUpdate.sameAsBefore
            } else {
                self.storedAppLanguage = language
                T21EnvironmentLogger.info("Language changed: '\(language)'")
                self.notifyLanguageChanged(language)
                return LanguageUpdate.updated
            }
        } else {
            T21EnvironmentLogger.warning("Setting an unsupported language: \(language)")
            return LanguageUpdate.notSupported
        }
    }
    
    public func getAppLanguage() -> String {
        if self.storedAppLanguage != nil {
            return self.storedAppLanguage!
        } else {
            T21EnvironmentLogger.warning("App language couldn't be configured.")
            return ""
        }
    }
    
    
    public func localizedString( _ string: String?) -> String {
        if !self.getAppLanguage().isEmpty {
            if string != nil {
                return NSLocalizedString(string!, tableName: self.storedAppLanguage?.uppercased(), bundle: Bundle.main, value: "", comment: "")
            } else {
                return ""
            }
        } else {
            T21EnvironmentLogger.warning("The app language is not configured.")
            return ""
        }
    }
    
    //MARK: Configuration environment
    
    public func getConfigurationName() -> String {
        return Bundle.main.infoDictionary!["Configuration"] as! String
    }
    
    public func configuration() -> Dictionary<String,Any> {
        
        guard let configurations = self.environments["configurations"] as? Dictionary<String,Any> else {
            T21EnvironmentLogger.warning("Malformed json: 'configurations' key not found.")
            return Dictionary<String,Any>()
        }
        guard let conf = configurations[getConfigurationName()] as? Dictionary<String, Any> else {
            T21EnvironmentLogger.warning("Malformed json: The current configuration (\(getConfigurationName())) was not found.")
            return Dictionary<String,Any>()
        }
        
        return conf
    }
    
    
    //MARK: Private
    
    private let notifier = T21Notifier<T21EnvironmentNotifications>()
    
    private var environments: Dictionary<String,Any> = Dictionary<String,Any>()
    
    private let storedAppLanguageKey = "T21Environment.appLanguage"
    
    private var m_storedAppLanguage: String?
    
    private var storedAppLanguage: String? {
        get {
            if m_storedAppLanguage == nil {
                m_storedAppLanguage = UserDefaults.standard.string(forKey: storedAppLanguageKey)
            }
            return m_storedAppLanguage
        }
        
        set(newValue) {
            m_storedAppLanguage = newValue
            if newValue != nil {
                UserDefaults.standard.set(newValue!, forKey: storedAppLanguageKey)
            } else {
                UserDefaults.standard.removeObject(forKey: storedAppLanguageKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    private func getPreferredLanguage() -> String? {
        let preferredLocale = Locale.preferredLanguages.first!
        var preferredLanguage = preferredLocale.components(separatedBy: "-").first
        
        if preferredLanguage == nil {
            preferredLanguage = preferredLocale.components(separatedBy: "_").first
        }
        return preferredLanguage
    }
    
    private func initializeAppLanguageData() -> String? {
        
        let storedLanguage = self.storedAppLanguage
        if storedLanguage != nil && self.isLanguageSupported(storedLanguage!) {
            _ = self.setAppLanguage(storedLanguage!)
        } else {
            //no stored language (first time) or stored language not supported anymore
            if let preferredLanguage = getPreferredLanguage() {
                if self.isLanguageSupported(preferredLanguage) {
                    _ = self.setAppLanguage(preferredLanguage)
                } else {
                    
                    if availableLanguages().count > 0 {
                        if let availableLanguage = availableLanguages().firstObject as? String {
                            _ = self.setAppLanguage(availableLanguage)
                        } else {
                            T21EnvironmentLogger.error("Malformed json: 'languages' array must contain string items.")
                        }
                    } else {
                        T21EnvironmentLogger.error("Malformed json: 'languages' array must contain at least one item.")
                    }
                }
            } else {
                T21EnvironmentLogger.error("PreferredLanguage can't be determined.")
            }
        }
        
        return self.storedAppLanguage
    }
    
    private func isLanguageSupported(_ language: String) -> Bool {
        var available = false
        for element in availableLanguages() {
            if let availableLanguage = element as? String {
                if language.compare(availableLanguage, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == ComparisonResult.orderedSame {
                    available = true
                }
            }
        }
        
        return available
    }
    
    private func checkEnvironmentsFormat( _ environments: Dictionary<String,Any>) -> Bool {
        
        guard environments["languages"] is NSArray else {
            T21EnvironmentLogger.error("Malformed json: 'languages' key not found.")
            return false
        }
        
        let languages = environments["languages"] as! NSArray
        guard languages.count > 0 else {
            T21EnvironmentLogger.error("Malformed json: No available 'languages' found.")
            return false
        }
        
        guard environments["configurations"] is NSDictionary else {
            T21EnvironmentLogger.error("Malformed json: 'configurations' key not found.")
            return false
        }
        
        _ = configuration() //the method checks for configurations
        
        return true
    }
    
    private func availableLanguages() -> NSArray {
        return self.environments["languages"] as! NSArray
    }
}
