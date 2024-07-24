cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.4.2"
  sha256 arm:   "0fad90b0f5f7baef6106138cfef3a6e0f1faa0daf268aae12d9883dd102d6f1a",
         intel: "149cecf163897d56dac084b3fae7f45f92be9654d9e1d9250f0c04161c5139aa"

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