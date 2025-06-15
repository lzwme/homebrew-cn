cask "iconset" do
  arch arm: "arm64-"

  version "2.5.0"
  sha256 arm:   "ed567c877bb0b7ba6889edc857f7cc83deb1f4e8c6bfc692ae7eb97e9ef9452c",
         intel: "20ec982a39fc513ade4526a1f87f30067931b70072b6cc2395cf5c17d4a28809"

  url "https:github.comIconsetAppiconsetreleasesdownloadv#{version}Iconset-#{version}-#{arch}mac.zip",
      verified: "github.comIconsetAppiconset"
  name "Iconset"
  desc "Organise icon sets and packs in one place"
  homepage "https:iconset.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Iconset.app"

  zap trash: [
    "~LibraryApplication SupportIconset",
    "~LibraryPreferencesio.iconset.app.plist",
    "~LibrarySaved Application Stateio.iconset.app.savedState",
  ]
end