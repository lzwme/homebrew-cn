cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.6.5"
  sha256 arm:   "c7d67101094080b302fdb34d1258949feb4a093c8a0d4797d0776c858d682e26",
         intel: "627ea05d403248f9c4969272acc39007555ed234cfdba4436c47ded37f07d67b"

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