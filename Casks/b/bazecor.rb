cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.6.4"
  sha256 arm:   "b443a5a875d5f547bdc7b2a915d9bfe7b4263834d84482d3584699700bb9f084",
         intel: "88e15288179d2e36874c8a393192910bce6010743e2dab36f64e1af2f204753e"

  url "https:github.comDygmalabBazecorreleasesdownloadv#{version}Bazecor-#{version}-#{arch}.dmg",
      verified: "github.comDygmalabBazecor"
  name "Bazecor"
  desc "Graphical configurator for Dygma Raise keyboards"
  homepage "https:dygma.compagesprogrammable-split-keyboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Bazecor.app"

  zap trash: [
    "~LibraryApplication SupportBAZECOR",
    "~LibraryPreferencescom.dygmalab.bazecor.plist",
    "~LibrarySaved Application Statecom.dygmalab.bazecor.savedState",
  ]
end