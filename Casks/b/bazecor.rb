cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.6.1"
  sha256 arm:   "ed53a11a50737e236f6a8d343f37963c6ccabbcc4d0c2ee0931d28bf42f6b025",
         intel: "552e23b3fe28005343857112112737a643720998ef5b6edc07bf871c2b0f92eb"

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