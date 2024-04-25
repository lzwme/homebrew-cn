cask "cityofzion-neon" do
  arch arm: "arm64", intel: "x64"

  version "2.23.11"
  sha256 arm:   "e3889a9ed1146b8a923d1cdadbe5fb5496c89151b551b64892970b991024a364",
         intel: "3b0cb45f06c9f6f8e9d7a6ba7d20448b42f80c4308bc9b4215d36fb246a90540"

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