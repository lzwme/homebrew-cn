cask "overt" do
  arch arm: "arm64", intel: "x64"

  version "0.6.0"
  sha256 arm:   "ba1a584b1c0a3afcefdb4dc25aebd829d8395c744b8def525bcf63b1af24d1cf",
         intel: "7d9aa67e7c314034b1307aa36a0cf701e88fa3e6c659dfced3d7740693606e21"

  url "https:github.comGetOvertOvertreleasesdownloadv#{version}Overt-darwin-#{arch}-#{version}.zip",
      verified: "github.comGetOvertOvert"
  name "Overt"
  desc "Open app store"
  homepage "https:getovert.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Overt.app"

  zap trash: [
    "~LibraryApplication SupportOpenStore",
    "~LibraryApplication SupportOvert",
    "~LibraryCachesOpenStore_v1",
    "~LibraryCachesOpenStore_v2",
    "~LibraryCachesOpenStore_v3",
    "~LibraryCachesOvert_v4",
    "~LibraryCachesOvert_v5",
    "~LibraryCachesOvert_v6",
    "~LibraryPreferencesapp.getopenstore.OpenStore.plist",
    "~LibraryPreferencesapp.getovert.Overt.plist",
  ]
end