cask "ytmdesktop-youtube-music" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "2.0.0"
    sha256 "c7a7734d295eaa3a8a7d42db2c2013618fd3fc06e9600d1c1485e1eec153b0cd"

    url "https:github.comytmdesktopytmdesktopreleasesdownloadv#{version}YouTube-Music-Desktop-App-darwin-#{arch}-#{version}.zip",
        verified: "github.comytmdesktopytmdesktop"
  end
  on_intel do
    version "2.0.5"
    sha256 "c1de73b67b9258be0e83383556d9e49c370d2f5dc6122e3e531cbe3f95146b7b"

    url "https:github.comytmdesktopytmdesktopreleasesdownloadv#{version}YouTube-Music.Desktop.App-darwin-#{arch}-#{version}.zip",
        verified: "github.comytmdesktopytmdesktop"
  end

  name "YouTube Music Desktop App"
  desc "YouTube music client"
  homepage "https:ytmdesktop.app"

  # Not every GitHub release provides a file for both architectures, so we check
  # multiple recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(Desktop[._-]App[._-]darwin[._-](?:#{arch})[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$i)
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

  app "YouTube Music Desktop App.app"

  zap trash: [
    "~LibraryPreferencesapp.ytmd.plist",
    "~LibrarySaved Application Stateapp.ytmd.savedState",
  ]
end