cask "tagspaces" do
  arch arm: "arm64", intel: "x64"

  version "6.1.1"
  sha256 arm:   "3667492fab63d4100e6db826773d1bc7a9ca35c691feaf4b2c76f2d3d1b244aa",
         intel: "6f4b808df7fc2035903fa30b93cca92cc92e798ae818ee89edea7eba23198645"

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