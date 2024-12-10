cask "appium-inspector" do
  arch arm: "arm64", intel: "x64"

  version "2024.12.1"
  sha256 arm:   "4d9b514842614de045daa7926df49279a064b6b4e15cff0a683131da676ba9dd",
         intel: "1118bbeb306d58192024a83da0604bca1a5238989eb4b9d369b90e6653916f38"

  url "https:github.comappiumappium-inspectorreleasesdownloadv#{version}Appium-Inspector-#{version}-mac-#{arch}.zip"
  name "Appium Inspector GUI"
  desc "GUI inspector for mobile apps"
  homepage "https:github.comappiumappium-inspector"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^Appium.*?v?(\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.(?:dmg|pkg|zip)$i)
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

  app "Appium Inspector.app"

  zap trash: [
    "~LibraryApplication Supportappium-inspector",
    "~LibraryLogsAppium Inspector",
    "~LibraryPreferencesio.appium.inspector.plist",
    "~LibrarySaved Application Stateio.appium.inspector.savedState",
  ]
end