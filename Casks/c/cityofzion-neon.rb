cask "cityofzion-neon" do
  arch arm: "arm64", intel: "x64"

  version "2.23.10"
  sha256 arm:   "a0b6bd245d8e83628fdd2a8df19c5cd5e485f21570cdcde1c32b4091f08b6448",
         intel: "e0859a8a6c453dd3b8460373d5e2a89d06a2f3031c3a307c582b2600f4d2b291"

  url "https:github.comCityOfZionneon-walletreleasesdownloadv#{version}Neon.#{version}.#{arch}.dmg"
  name "Neon Wallet"
  desc "Light wallet for the NEO blockchain"
  homepage "https:github.comCityOfZionneon-wallet"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Neon.app"

  zap trash: [
    "~LibraryApplication SupportNeon",
    "~LibraryPreferencescom.electron.neon.helper.plist",
    "~LibraryPreferencescom.electron.neon.plist",
    "~LibrarySaved Application Statecom.electron.neon.savedState",
  ]
end