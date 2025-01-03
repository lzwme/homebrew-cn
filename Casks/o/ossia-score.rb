cask "ossia-score" do
  arch arm: "AppleSilicon", intel: "Intel"

  on_arm do
    version "3.3.2"
    sha256 "8cb5b0038633fa43c1c160985802c6445e1a7a7fcbd0be47b126f7d9d74507cf"
  end
  on_intel do
    version "3.3.2"
    sha256 "c6ff72d1dbb78ed4f61fd6e7e31bb5271b988016d1bfc42d6a4f8051b21740f2"
  end

  url "https:github.comossiascorereleasesdownloadv#{version}ossia.score-#{version}-macOS-#{arch}.dmg",
      verified: "github.comossiascore"
  name "ossia score"
  desc "Interactive sequencer for intermedia art"
  homepage "https:ossia.io"

  livecheck do
    url :url
    regex(ossia[._-]score[._-]v?(\d+(?:[.-]\d+)+)[._-]macOS[._-]#{arch}\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  depends_on macos: ">= :catalina"

  app "ossia score.app"

  zap trash: [
    "~LibraryPreferencesio.ossia.score.plist",
    "~LibrarySaved Application Stateio.ossia.score.savedState",
  ]
end