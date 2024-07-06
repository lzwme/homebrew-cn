cask "ossia-score" do
  version "3.2.3-3"
  sha256 "cc98bc08d5719842f8ddf895e5c28aa08e37fbbea471c28d8fc4a9c2d5e0629f"

  url "https:github.comossiascorereleasesdownloadv#{version}ossia.score-#{version}-macOS.dmg",
      verified: "github.comossiascore"
  name "ossia score"
  desc "Interactive sequencer for intermedia art"
  homepage "https:ossia.io"

  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ossia score.app"

  zap trash: [
    "~LibraryPreferencesio.ossia.score.plist",
    "~LibrarySaved Application Stateio.ossia.score.savedState",
  ]

  caveats do
    requires_rosetta
  end
end