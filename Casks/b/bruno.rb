cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.38.0"
  sha256 arm:   "15158a249152e74d7f3ad145d8b97100485c663d05266f706a90ffa3409f0469",
         intel: "b0c41f3d795ff9aa53ec54398f8bcc7118b01bd99558839c8da297ac43d2b7c1"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Opensource IDE for exploring and testing api's"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end