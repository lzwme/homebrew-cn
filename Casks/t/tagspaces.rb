cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.4.10"
  sha256 arm:   "e88ff51f10414ec01934797cc3174bc0bd6ba7569a3afdcf39b8492f7e52d0a4",
         intel: "2f42ea4af615057e1cadefd3a94044521da5d84af82f7fcb679cfbb089930efe"

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