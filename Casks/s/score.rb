cask "score" do
  arch arm: "AppleSilicon", intel: "Intel"

  version "3.2.0"
  sha256 arm:   "6dbc9a18d286988a0f357be32a89395f627ac5bec1534a17f8eaaa284238713e",
         intel: "1ada9e1a840a2f2b9c8e74a871c40c10a5ed72d6724d016b2d915c6e9c60b428"

  url "https:github.comossiascorereleasesdownloadv#{version}ossia.score-#{version}-macOS-#{arch}.dmg",
      verified: "github.comossiascore"
  name "ossia score"
  desc "Interactive sequencer for intermedia art"
  homepage "https:ossia.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ossia score.app"

  zap trash: [
    "~LibraryPreferencesio.ossia.score.plist",
    "~LibrarySaved Application Stateio.ossia.score.savedState",
  ]
end