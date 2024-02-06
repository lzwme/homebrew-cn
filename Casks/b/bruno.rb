cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "aa638043908fe6664fd3077a4a8ae49608b4e3b48bacdc726a29c951ece255c2",
         intel: "9ff9cf5eabeb9f434b8eadf0a246ad92328abae9154a34391cb7f9100cf8ec54"

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