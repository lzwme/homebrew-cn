cask "ossia-score" do
  arch arm: "AppleSilicon", intel: "Intel"

  version "3.5.2"
  sha256 arm:   "3673897e2956029bd2cbbc53d5771b3b1b418252df6b199be72430bebbd870f0",
         intel: "3104e911cd5e51bcff5b60676f6f599a8cbee45fd42ee4ca4a6a74d3d9186adb"

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