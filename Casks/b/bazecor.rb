cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "3f135314f764e0015dffc39ea8a196095220f8bce75ffe9104079ea06bec49d1",
         intel: "18aa87da0aa697ff1bcd766defc26eeb88e2bd6d77240b4bd30f0b99d79ba51a"

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