cask "bazecor" do
  arch arm: "arm64", intel: "x64"

  version "1.5.1"
  sha256 arm:   "2ed5b66166af98e652b58ab4936723c20306b87e6b35da66e77a282279e0a0ff",
         intel: "310aa952a5abbbeed116f83150ce896f199b492ae3fff533ecdafffce3370760"

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