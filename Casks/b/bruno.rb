cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.22.0"
  sha256 arm:   "5c6b1656659e822a25833c8662bf2fbd7380d9a1d9e49f462f2a89c30e63453f",
         intel: "b2496429f0735240908caa060a76efbac0ae782cd58cec1b1ebdcde38814dcab"

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