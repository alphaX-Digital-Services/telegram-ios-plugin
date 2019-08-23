import PassKit
import TDLib

@objc(TelegramJson) class TelegramJson: CDVPlugin {
    var coordinator: Coordinator?
    var authState: String = "Undefined"
    var chats: [Int64]?

    @objc(create:)
    public func create(command: CDVInvokedUrlCommand) {
        coordinator = Coordinator(client: TDJsonClient(), apiId: command.arguments![0] as! Int32, apiHash: "\(command.arguments[1])", useTestDc: command.arguments![2] as! Bool)
        coordinator!.authorizationState.subscribe(on: .main) { event in
            guard let state = event.value else {
                return
            }
            switch state {
            case .waitTdlibParameters, .waitEncryptionKey:
                // Ignore these! TDLib-iOS will handle them.
                break
            case .waitPhoneNumber:
                // Show sign in screen.
                print("waitPhoneNumber")
                self.authState = "waitPhoneNumber"
            case let .waitCode(isRegistered, tos, codeInfo):
                // Show code input screen.
                print(".waitCode")
                self.authState = "waitCode"
                if isRegistered == false {
                    self.authState = "notRegistered"
                }
            case .waitPassword(let passwordHint, _, _):
                // Show passoword screen (will only happen when the user has setup 2FA).
                print("Wait pass")
                self.authState = "waitPass"
            case .ready:
                // Show main view
                print("READY")
                self.authState = "ready"
            case .loggingOut, .closing, .closed:
                self.authState = "destroyed"
            }
        }

        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        if coordinator != nil {
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: "Created"
            )
        }

        commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )

        print(coordinator!)
    }

    @objc(logout:)
    public func logout(command: CDVInvokedUrlCommand) {
        coordinator!.send(Destroy())
            .done { res in print(res) }
            .catch { err in print(err) }

        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: authState
        )

        commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }

    @objc(getAuthState:)
    public func getAuthState(command: CDVInvokedUrlCommand) {
        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: authState
        )

        commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }

    @objc(getChats:)
    public func getChats(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: "ERROR GETIING CHATS"
        )

        coordinator!.send(GetChats(offsetOrder: "\(command.arguments[0])", offsetChatId: command.arguments![1] as! Int53, limit: command.arguments![2] as! Int32))
            .done { res in
                print(res)
                self.chats = res.chatIds
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: self.chats
                )
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
            .catch { err in
                print(err)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
    }

    @objc(getChatHistory:)
    public func getChatHistory(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: "ERROR SENDING PHONE NUMBER"
        )

        coordinator!.send(GetChatHistory(chatId: command.arguments![0] as! Int53, fromMessageId: command.arguments![1] as! Int53, offset: command.arguments![2] as! Int32, limit: command.arguments![3] as! Int32, onlyLocal: false))
            .done { res in
                print(res)
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: self.jsonEncode(_obj: res)
                )
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
            .catch { err in
                print(err)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
    }

    @objc(sendPhoneNumber:)
    public func sendPhoneNumber(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: "ERROR SENDING PHONE NUMBER"
        )

        coordinator!.send(SetAuthenticationPhoneNumber(phoneNumber: "\(command.arguments[0])", allowFlashCall: false, isCurrentPhoneNumber: true))
            .done { res in
                print(res)
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: "SENDED"
                )

                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
            .catch { err in
                print(err)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
    }

    @objc(sendCode:)
    public func sendCode(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: "ERROR SENDING CODE"
        )

        coordinator!.send(CheckAuthenticationCode(code: "\(command.arguments[0])", firstName: "\(command.arguments[1])", lastName: ""))
            .done { res in
                print(res)
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: "OK!"
                )

                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
            .catch { err in
                print(err)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
            }
    }
    
    @objc(resendCode:)
    public func resendCode(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: "ERROR RESENDING CODE"
        )
        
        coordinator!.send(ResendAuthenticationCode())
            .done{ res in
            print("CODE RESENDED")
                
            pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: "RESENDED!"
                )
                
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
                
            }
            .catch{err in
                print(err)
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: command.callbackId
                )
        }
        
    }
    
    public func jsonEncode(_obj: Encodable) -> String {
        let codable = AnyEncodable(value: _obj)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(codable)
        return String(data: data, encoding: .utf8)!
    }
    
    struct AnyEncodable: Encodable {
        let value: Encodable
        
        func encode(to encoder: Encoder) throws {
            try self.value.encode(to: encoder)
        }
    }
}
