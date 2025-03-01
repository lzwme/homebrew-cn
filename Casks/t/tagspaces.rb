cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.3.2"
  sha256 arm:   "bf5f90eae524bf98904ddcda83fd4955ad242040d259da837d3b96b13cba31c5",
         intel: "726cd6ad706de32bb33899acae32bca1474d60ace5e74982a49cd47df6f4b8e4"

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