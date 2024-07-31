cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.4.3"
  sha256 arm:   "2417380e4c06c280285ca393d279de0dfd02e394bc930d57584d72fddeb26e13",
         intel: "856f790cd126d99ddcbf40f471f8d36a2f10556d118d0b6d42373f55c1b577ae"

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