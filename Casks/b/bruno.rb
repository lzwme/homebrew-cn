cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.23.0"
  sha256 arm:   "64689c6d76acf6234bcd236e598114e113bf3d546163029e743bdc0385a0abad",
         intel: "28e93d1bec5da1a1b81458fc8c2c8246a84478beb9b47b6de23f094bacfb7e60"

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