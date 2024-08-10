cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.4.4"
  sha256 arm:   "b90ad059abbb41946415ae2d109e4b980e7a2c05d45a107fb63c33ade98703d9",
         intel: "84d58710554553ec6df28b90022e5aa06dd92a742e0de5a524057a0033658e22"

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