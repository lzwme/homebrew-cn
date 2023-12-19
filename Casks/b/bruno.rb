cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.5.1"
  sha256 arm:   "3ad04b426a8488a1d442acb5fcf847d0c1237430362845dc2a3e0e4b656ba5c1",
         intel: "a2f6db659c9a24d7392911103d49132fdbcbaedf191a79339fdc918cba33fe01"

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