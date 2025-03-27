cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.4.2"
  sha256 arm:   "14ae15574fdb704b5095befa7638082f649f16d4ca132575c4388d9175daa869",
         intel: "fc8c796a0ffa75db30e78c4962acc15ad8deb5db851a087c0ca98aeaf351ae89"

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