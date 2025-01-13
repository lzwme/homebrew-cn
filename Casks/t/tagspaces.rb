cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.2.0"
  sha256 arm:   "af0d2f50dd8e501604c2677b83c430af4dbea2b8d556bf5a5cea5f8d6161a371",
         intel: "267951b517e31eda95c8c493445c93aeaa14b136ad6b846ea86d412d47ebfb78"

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