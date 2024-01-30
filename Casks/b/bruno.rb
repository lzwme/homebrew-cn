cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "507471e64a90b6b79d7d1376989d3449846758eb15308d5c64d053c88ab21f47",
         intel: "bc531a1975b9a54dc2d2be4189ea41a4e21b73870177a4bcb3e8aaf1031874d0"

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