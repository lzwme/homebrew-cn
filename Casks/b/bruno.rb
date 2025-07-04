cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "2.7.0"
  sha256 arm:   "a537da9e2356b2fd0d8a22ecd14f313b7bef381e7e662b6256e7a51678d8173d",
         intel: "19f5dce51c7c77a8adc7bda9a4f970e849c7dd2daaf7c78c05b419dcad64073a"

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