cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.5.0"
  sha256 arm:   "c5c04da2cf86cfbbd8972376fbef6d135779d65744a66dd6fc2c62198ea8ebbc",
         intel: "e179b0699b35046f65964dfba41d3a2d711ad307302b72095030331d1a2b37ea"

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