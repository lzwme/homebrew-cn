cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.6.0"
  sha256 arm:   "df6b350321aa80d3d10ccae0fc2c3cc3bd03d223372c77ae8436764d2108cf9b",
         intel: "93a433073838dc94624c4da919c6d8424daf3daae11e3d6907160404989678be"

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