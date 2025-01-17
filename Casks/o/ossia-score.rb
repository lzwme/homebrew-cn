cask "ossia-score" do
  arch arm: "AppleSilicon", intel: "Intel"

  on_arm do
    version "3.4.1"
    sha256 "c1ea3cb5946e8727a1b37e3ad0b5231a5d7c0a1ae11a5f6bbd42dd49802f9ce7"
  end
  on_intel do
    version "3.4.1"
    sha256 "38939b3da18eba7757a11ff46b89a985219c3938eed04ab3d6645f211b55e449"
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