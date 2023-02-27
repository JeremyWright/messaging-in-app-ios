//
//  MessagingController.swift
//

import SwiftUI
import SMIClientUI
import SMIClientCore

// TO DO: Replace this config value with a values from your Salesforce org.
enum Constants {
    static let organizationId: String = "TBD"
    static let developerName: String = "TBD"
    static let url: String = "https://TBD.salesforce-scrt.com"
}

class MessagingController: ObservableObject, HiddenPreChatDelegate {
    func core(_ core: CoreClient!, conversation: Conversation!,
              didRequestPrechatValues hiddenPreChatFields: [HiddenPreChatField]!,
              completionHandler: HiddenPreChatValueCompletion!) {

        for preChatField: HiddenPreChatField in hiddenPreChatFields {
            if preChatField.name == "Favorite_Pizza_Topping" {
                preChatField.value = "Black Olives"
            }
        }

        completionHandler(hiddenPreChatFields)
    }

    @Published var uiConfig: UIConfiguration?

    init() {
        resetConfig()
    }

    func resetConfig() {
        let conversationID = UUID()

        guard let url = URL(string: Constants.url) else {
            return
        }

        let uiConfig = UIConfiguration(serviceAPI: url,
                                       organizationId: Constants.organizationId,
                                       developerName: Constants.developerName,
                                       conversationId:conversationID )
        self.uiConfig = uiConfig
        CoreFactory.create(withConfig: uiConfig).setPreChatDelegate(delegate: self, queue: DispatchQueue.main)

        NSLog("Config created using conversation ID \(conversationID.description).")
    }
}
