cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "2.2.0"
  sha256 arm:   "1cb03976e08651bf87ad37179832e93c6546f93b1005c9541324da7c9458b80e",
         intel: "64a626f9f451d82f8dddeb1c5b661f1936215a44d3cc805d227a4faa546405e3"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Open source IDE for exploring and testing APIs"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end