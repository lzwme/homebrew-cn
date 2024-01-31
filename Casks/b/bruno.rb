cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.7.1"
  sha256 arm:   "bd356177de2928f9d309b496b7ddf9e66cbaaf9ed0de20ade203403dfbc82c95",
         intel: "cd4d4fc352d21d2fd62727c9ffb911b3dba4cdc9e668a558f57c7e7626ef573d"

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