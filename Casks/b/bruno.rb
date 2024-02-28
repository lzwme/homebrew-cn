cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.10.0"
  sha256 arm:   "872908499dc0c3fb688899112f75f6dba8d7bd711f77be5dd66c7750bc29482d",
         intel: "7ee755b41a9586f80629152003648c1595e57a2ed10cce1771dfc39b39f2a740"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Opensource IDE for exploring and testing api's"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end