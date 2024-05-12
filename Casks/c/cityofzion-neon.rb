cask "cityofzion-neon" do
  arch arm: "arm64", intel: "x64"

  version "2.23.13"
  sha256 arm:   "67c849465eca5f0113514f6e4c253fe9c8994fa64a56194d1dcd25611eb52560",
         intel: "cacdc79b01058daafac53576bfdb86eafe1c37eec9ec7d1b264ab1a0b4c79f16"

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