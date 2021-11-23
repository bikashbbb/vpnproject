import NetworkExtension
import OpenVPNAdapter
import os.log

extension NEPacketTunnelFlow: OpenVPNAdapterPacketFlow {}

class PacketTunnelProvider: NEPacketTunnelProvider {

    lazy var vpnAdapter: OpenVPNAdapter = {
        let adapter = OpenVPNAdapter()
        adapter.delegate = self
        return adapter
    }()

    let vpnReachability = OpenVPNReachability()
    var providerManager: NETunnelProviderManager!

    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?

    static var connectionIndex = 0;
    static var timeOutEnabled = true;
    
    func loadProviderManager(completion:@escaping (_ error : Error?) -> Void)  { 
            NETunnelProviderManager.loadAllFromPreferences { (managers, error)  in
                if error == nil {
                    self.providerManager = managers?.first ?? NETunnelProviderManager()
                    completion(nil)
                } else {
                    completion(error)
                }
            }
    }

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        PacketTunnelProvider.connectionIndex = PacketTunnelProvider.connectionIndex + 1;
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration
        else {
            fatalError()
        }

        guard let ovpnFileContent: Data = providerConfiguration["config"] as? Data else {
            fatalError()
        }
        //        let expireAt : Data? = providerConfiguration["expireAt"] as? Data? ?? nil
        let username : Data? = providerConfiguration["username"] as? Data? ?? nil
        let password : Data? = providerConfiguration["password"] as? Data? ?? nil
//        let timeOut : Data? = providerConfiguration["timeOut"] as? Data? ?? nil

        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
        
        //        let properties: OpenVPNConfigurationEvaluation
        do {
            try vpnAdapter.apply(configuration: configuration)
        } catch {
            completionHandler(error)
            return
        }
        let userString = String(decoding: username!, as: UTF8.self)
        let passString = String(decoding: password!, as: UTF8.self)
        let credentials = OpenVPNCredentials()
        credentials.username = userString
        credentials.password = passString
        
        do {
            try vpnAdapter.provide(credentials: credentials)
        } catch {
            completionHandler(error)
            return
        }
        vpnReachability.startTracking { [weak self] status in
            guard status == .reachableViaWiFi else { return }
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }
//        if timeOut != nil {
//            let timeOutParsedString = String(decoding: timeOut!, as: UTF8.self)
//            let timeOutParsed = Int.init(timeOutParsedString)
//            let index = PacketTunnelProvider.connectionIndex;
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timeOutParsed!)) {
//                if !PacketTunnelProvider.timeOutEnabled || PacketTunnelProvider.connectionIndex != index {
//                    return;
//                }
//                UserDefaults.init(suiteName: "YOUR_VPN_GROUP_IDENTIFIER")?.setValue("TIMEOUT", forKey: "vpnStatusGroup")
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(1)) {
//                self.stopVPN()
//                }
//            }
//        }
//        if expireAt != nil {
//
//            var expireAtDate:Date!;
//            let formatter = DateFormatter();
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
//            let expireAtString = String(decoding: expireAt!, as: UTF8.self)
//            expireAtDate = formatter.date(from: expireAtString);
//            var stopInSeconds = 10 * 60.0;
//            if expireAtDate.timeIntervalSinceNow > 0.0 {
//                stopInSeconds = expireAtDate.timeIntervalSinceNow
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(stopInSeconds)) {
//                self.stopVPN()
//                UserDefaults.init(suiteName: "YOUR_VPN_GROUP_IDENTIFIER")?.setValue("EXPIRED", forKey: "vpnStatusGroup")
//            }
//        }
        startHandler = completionHandler
        vpnAdapter.connect(using: packetFlow)
    }
    
    @objc func stopVPN() {
        loadProviderManager { (err :Error?) in
            if err == nil {
                self.providerManager.connection.stopVPNTunnel();
            }
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopHandler = completionHandler
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        vpnAdapter.disconnect()
    }

}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        networkSettings?.dnsSettings?.matchDomains = [""]
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
        _updateConnectionStatus(openVPNAdapter)
    }
    
    func _updateConnectionStatus(_ openVPNAdapter: OpenVPNAdapter) {
        var toSave = ""
           let formatter = DateFormatter();
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
           if openVPNAdapter.transportStatistics.lastPacketReceived != nil{
               toSave += formatter.string(from: openVPNAdapter.transportStatistics.lastPacketReceived!)
           }
           toSave+="_"
           toSave += String(openVPNAdapter.transportStatistics.packetsIn)
           toSave+="_"
           toSave += String(openVPNAdapter.transportStatistics.bytesIn)
           toSave+="_"
           toSave += String(openVPNAdapter.transportStatistics.bytesOut)
           UserDefaults.init(suiteName: "YOUR_VPN_GROUP_IDENTIFIER")?.setValue(toSave, forKey: "connectionUpdate")
    }
    
    func _updateEvent(_ event: OpenVPNAdapterEvent) {
        var toSave = ""
        switch event {
        case .connected:
            toSave = "CONNECTED"
        case .disconnected:
            toSave = "DISCONNECTED"
        case .connecting:
            toSave = "CONNECTING"
        case .reconnecting:
            toSave = "RECONNECTING"
        default:
            toSave = "INVALID"
        }
        UserDefaults.init(suiteName: "YOUR_VPN_GROUP_IDENTIFIER")?.setValue(toSave, forKey: "vpnStatusGroup")
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        PacketTunnelProvider.timeOutEnabled = true;
        _updateConnectionStatus(openVPNAdapter)
        _updateEvent(event)
        switch event {
        case .connected:
        PacketTunnelProvider.timeOutEnabled = false;
            if reasserting {
                reasserting = false
            }
            guard let startHandler = startHandler else { return }
            startHandler(nil)
            self.startHandler = nil
        case .disconnected:
            PacketTunnelProvider.timeOutEnabled = false;
            guard let stopHandler = stopHandler else { return }
            if vpnReachability.isTracking {
                vpnReachability.stopTracking()
            }
            stopHandler()
            self.stopHandler = nil
        case .reconnecting:
            reasserting = true
        default:
            break
        }
    }
 
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        _updateConnectionStatus(openVPNAdapter)
        // Handle only fatal errors
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal == true else {
            return
        }
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }
 
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        _updateConnectionStatus(openVPNAdapter) 
    }

}
