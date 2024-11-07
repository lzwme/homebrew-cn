cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.5.3"
  sha256 arm:   "4e4d05e6bdbeb95f6feb5440c508b67ec5236ab3833268601b72afa0efafc8b0",
         intel: "dd674690345bcee49bad171bea676435a6d769b9db0d95e88a447a879ca030bf"

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