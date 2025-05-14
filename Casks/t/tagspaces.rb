cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.4.7"
  sha256 arm:   "925eaf645128a928c7521322da67607a2caeddbcaec2ab7cc00127d810420df8",
         intel: "26536b97d4bc88cfce472cd9a9f7e9f8d49b6bec7709d5840aaa675f14c776b3"

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