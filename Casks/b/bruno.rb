cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.14.0"
  sha256 arm:   "1fb3986cbe00003a3a2f233b29dd7342f887af67c19b7a0aa71b6e41871914fa",
         intel: "fffcfae070b8dff14ef4966f1c715a7abca39467c8d4b3a78fa5bca39e0752c2"

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