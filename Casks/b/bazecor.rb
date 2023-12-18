cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.3.8"
  sha256 arm:   "4c155b472723b33746d9284a6183aad111e24ba42815f7c2a298b22303adc187",
         intel: "cbd044ce836eb5916d04e79e4ed579c60358c3c167e9d8566fba7f15baf2a568"

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