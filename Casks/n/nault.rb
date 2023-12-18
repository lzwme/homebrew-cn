cask "nault" do
  version "1.18.3"
  sha256 "02e768906e23774219907feb95ec84782449b3f02b575f2c653a500f24b6218c"

  url "https:github.comNaultNaultreleasesdownloadv#{version}Nault-#{version}-Mac.dmg"
  name "Nault"
  desc "Wallet for the Nano cryptocurrency with support for hardware wallets"
  homepage "https:github.comNaultNault"

  auto_updates true

  app "Nault.app"

  zap trash: [
    "~LibraryApplication Supportnault",
    "~LibraryLogsNault",
    "~LibraryPreferencescc.nault.plist",
    "~LibrarySaved Application Statecc.nault.savedState",
  ]
end