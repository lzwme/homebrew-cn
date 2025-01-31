cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.6.3"
  sha256 arm:   "20617463fbc40b28dbc73dcf7d37d2e51cf90e9abc3a57194318ebe630807f98",
         intel: "6eda732342f8088a68dd620b7ae68e314d23467248dab1b73fa14fc905891992"

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