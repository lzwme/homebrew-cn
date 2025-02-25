cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.3.1"
  sha256 arm:   "851e6f6d0d7096632753b7dd3eb3743bf9c725953c15f5ffc9818aab020e8d10",
         intel: "6db3a91c163f5ecd8feed56f918a1899d17fd963dae1b83dabb797433f316772"

  url "https:github.comtagspacestagspacesreleasesdownloadv#{version}tagspaces-mac-#{arch}-#{version}.dmg",
      verified: "github.comtagspacestagspaces"
  name "TagSpaces"
  desc "Offline, open-source, document manager with tagging support"
  homepage "https:www.tagspaces.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TagSpaces.app"

  zap trash: [
    "~LibraryApplication SupportTagSpaces",
    "~LibraryPreferencesorg.tagspaces.desktopapp.plist",
    "~LibrarySaved Application Stateorg.tagspaces.desktopapp.savedState",
  ]
end