cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.5.4"
  sha256 arm:   "bb298cde2bef303323c13ca130ccb25d7bfc09ab64ddeece9e8f04584c39d170",
         intel: "e739c40f2d47a3665b15cabc04b39e3ee83fc2ad9dcced2d2c9c290115d9e09b"

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