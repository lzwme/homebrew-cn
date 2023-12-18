cask "score" do
  version "3.1.12"
  sha256 "4033767b7b90aee5e973acbfaf5f1a21f17f98361661bb7a2867836591237bcf"

  url "https:github.comossiascorereleasesdownloadv#{version}ossia.score-#{version}-macOS.dmg",
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