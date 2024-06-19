cask "score" do
  arch arm: "AppleSilicon", intel: "Intel"

  version "3.2.1"
  sha256 arm:   "52799d7ae78e2d400d0a6639458061c6156d37767e8b40fd1c85ab3235fd7557",
         intel: "515ad8834263a44564147e46f73d3ae861b646d1123d163ec277dd55ce890b49"

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