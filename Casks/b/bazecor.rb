cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.4.0"
  sha256 arm:   "0c55b9c8cb4db2cdb8d000aac97fdfbb14e4476e8f1a5140636e4c37f7bcf93d",
         intel: "97c059f9be2093089a399c63c075ed71a7a63ceb117cdb6fd16d03ed8e7b886d"

  url "https:github.comDygmalabBazecorreleasesdownloadv#{version}Bazecor-#{version}-#{arch}.dmg",
      verified: "github.comDygmalabBazecor"
  name "Bazecor"
  desc "Graphical configurator for Dygma Raise keyboards"
  homepage "https:dygma.compagesprogrammable-split-keyboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Bazecor.app"

  zap trash: [
    "~LibraryApplication SupportBAZECOR",
    "~LibraryPreferencescom.dygmalab.bazecor.plist",
    "~LibrarySaved Application Statecom.dygmalab.bazecor.savedState",
  ]
end