cask "cityofzion-neon" do
  arch arm: "arm64", intel: "x64"

  version "2.24.0"
  sha256 arm:   "e6138cea6e2dd23a52f8633d5379d27065228628c527634fcf9a03f507a309d2",
         intel: "77ca53d27e24ffd2d6dc3cecb20ee661ae13d86961b44c7b46d9d6c154f4207f"

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