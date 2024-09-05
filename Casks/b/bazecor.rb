cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.4.5"
  sha256 arm:   "5d383ebe9b7b964995e86884d7c07c553c2f0ef5ac361869685ac61820586ae5",
         intel: "98f63256f3d0b5595c26e0678b2f1f2a448ddc6440cdd4bf4b25d84c62d5d769"

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