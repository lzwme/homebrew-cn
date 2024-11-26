cask "cityofzion-neon" do
  arch arm: "arm64", intel: "x64"

  version "2.25.0"
  sha256 arm:   "68ef2daa7e0f6d415dbb3101cfd520b04a01cd9d303b11df44508f16406f42b0",
         intel: "d21fdab52ed49861b85861b7ce2cd6823489db140b2e9c1864a6608c518ce5c4"

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