cask "bot-framework-emulator" do
  version "4.14.1"
  sha256 "274363551f54f64093437ad81109098639c62d70449a5f4afb0a0bc6033ce270"

  url "https:github.comMicrosoftBotFramework-Emulatorreleasesdownloadv#{version}botframework-emulator-#{version}-mac.zip"
  name "Microsoft Bot Framework Emulator"
  desc "Test and debug chat bots built with the Bot Framework SDK"
  homepage "https:github.comMicrosoftBotFramework-Emulator"

  auto_updates true

  app "Bot Framework Emulator.app"

  uninstall quit: "com.electron.botframework-emulator"

  zap trash: [
    "~LibraryApplication Supportbotframework-emulator",
    "~LibraryCachescom.electron.botframework-emulator",
    "~LibraryCachescom.electron.botframework-emulator.ShipIt",
    "~LibraryPreferencescom.electron.botframework-emulator.helper.plist",
    "~LibraryPreferencescom.electron.botframework-emulator.plist",
    "~LibrarySaved Application Statecom.electron.botframework-emulator.savedState",
  ]
end