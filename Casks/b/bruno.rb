cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.24.0"
  sha256 arm:   "ddd782e607e21ef37269edf701963955c512454a0dca5218f63b3fbe62ddfcb8",
         intel: "ce3f59180bb7b66ef5bb1884754c098498e3c8339197eee720865bacfb8986bc"

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