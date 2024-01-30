cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.3.11"
  sha256 arm:   "08a5cdd809cba2296631ef23d8333205d948a9188fc90e1c88e8a40446028124",
         intel: "d4a9a2ccb86ab6e9518ca7a14df82310be0442902c2df3f1d8d70377cd3b53fa"

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