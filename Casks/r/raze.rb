cask "raze" do
  version "1.10.0"
  sha256 "31125be24872c694b605a5ed7267a31a24d8e86eae377b7dce9faf922312d27b"

  url "https:github.comcoelckersRazereleasesdownload#{version}raze-macos-#{version}.zip"
  name "Raze"
  desc "Build engine port backed by GZDoom tech"
  homepage "https:github.comcoelckersRaze"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^raze[._-]macos[._-]v?(\d+(?:\.\d+)+)\.zip$i)
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

  app "Raze.app"

  zap trash: [
    "~DocumentsRaze",
    "~LibraryApplication SupportRaze",
    "~LibraryPreferencesorg.drdteam.raze.plist",
    "~LibraryPreferencesorg.zdoom.raze.plist",
    "~LibraryPreferencesraze.ini",
    "~LibrarySaved Application Stateorg.drdteam.raze.savedState",
    "~LibrarySaved Application Stateorg.zdoom.raze.savedState",
  ]
end