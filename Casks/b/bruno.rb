cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.19.0"
  sha256 arm:   "c701c36207cb4e41205549069c3567e4782a12ee6d7fa7cc7a86889687bedc35",
         intel: "3edc2f29a457df399cedd0427be1a8532c98d8c51873741a5eabe1a2297e316f"

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